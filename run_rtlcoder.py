#!/usr/bin/env python3
"""
Script para regenerar los 15 códigos del benchmark con RTLCoder.
Autor: Luis Montenegro — CINVESTAV Guadalajara 2026

Uso:
    python run_rtlcoder.py --model lmstudio    # LM Studio (RECOMENDADO para laptop)
    python run_rtlcoder.py --model hf          # HuggingFace transformers (servidor)
    python run_rtlcoder.py --model ollama      # Ollama local

INSTRUCCIONES LM STUDIO:
    1. Descargar modelo: buscar "mradermacher/RTLCoder-v1.1-GGUF" en LM Studio
       (elegir versión Q4_K_M ~4GB o Q5_K_M ~5GB según RAM disponible)
    2. Cargar el modelo en LM Studio → pestaña "Local Server" → Start Server
    3. Correr: python run_rtlcoder.py --model lmstudio
    El servidor de LM Studio por defecto escucha en http://localhost:1234

Instalación previa (servidor HuggingFace):
    pip install transformers accelerate torch bitsandbytes

Modelos RTLCoder en HuggingFace:
    ishorn5/RTLCoder-Deepseek-v1.1   ← (ya lo tienes en rtlcoder_deepseek_v1.1/)
    ishorn5/RTLCoder-v1.1            ← este es el "RTLCoder base" (codigo_rtlcoder)
    GGUF para LM Studio: mradermacher/RTLCoder-v1.1-GGUF
"""

import argparse
import os
import sys
import time

# ─── Configuración ────────────────────────────────────────────────────────────

OUTPUT_DIR = "./codigo_rtlcoder_nuevo"   # Carpeta de salida (cámbiala si quieres)

# Modelo a usar (por defecto: RTLCoder base en Mistral)
HF_MODEL_ID = "ishorn5/RTLCoder-v1.1"

# Parámetros de generación
MAX_NEW_TOKENS = 1024
TEMPERATURE    = 0.2       # Bajo para código determinístico
TOP_P          = 0.95
DO_SAMPLE      = True

# ─── Los 15 prompts del benchmark ─────────────────────────────────────────────

PROMPTS = {

# ═══════════════════════════════ ALU 8 bits ═══════════════════════════════════

"alu_v1": """Implementa el siguiente componente RTL en SystemVerilog siguiendo la especificación técnica a continuación:

COMPONENTE: Arithmetic Logic Unit (ALU)
VERSIÓN: 1.0
ESTÁNDAR: IEEE 1800-2017 (SystemVerilog)

1. DECLARACIÓN DEL MÓDULO
Nombre: alu
Tipo: Combinacional (sin reloj, sin reset)
Puertos:
- a [7:0]      input logic  — Operando A (sin signo)
- b [7:0]      input logic  — Operando B (sin signo)
- op [3:0]     input logic  — Selector de operación
- result [7:0] output logic — Resultado de la operación
- zero         output logic — Asertado cuando result == 0
- carry        output logic — Carry/borrow en operaciones aritméticas
- overflow     output logic — Desbordamiento en complemento a 2
- negative     output logic — Igual a result[7]

2. TABLA DE OPERACIONES
op=4'h0  ADD: result = a + b; carry = bit[8]
op=4'h1  SUB: result = a - b; carry = borrow
op=4'h2  AND: result = a & b
op=4'h3  OR:  result = a | b
op=4'h4  XOR: result = a ^ b
op=4'h5  NOT: result = ~a
op=4'h6  SHL: result = a << 1; carry = a[7]
op=4'h7  SHR: result = a >> 1; carry = a[0]
op=4'h8  SLT: result = (a < b) ? 8'h01 : 8'h00
op=4'h9  MUL: result = a[3:0] * b[3:0] (8 bits)
otros    NOP: result = 0, todas las banderas = 0

3. LÓGICA DE BANDERAS
zero     = (result == 8'h00)
carry    = solo activo en ADD, SUB, SHL, SHR
overflow = solo activo en ADD y SUB
  ADD: (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7])
  SUB: (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7])
negative = result[7]

4. REQUISITOS DE CODIFICACIÓN
- Usar always_comb (no always @(*))
- No se permiten latches inferidos
- Código 100% sintetizable
- No usar imports de paquetes externos

GENERA ÚNICAMENTE el módulo `alu` completo y funcional.""",

"alu_v2": """Quiero que me ayudes a crear un módulo de SystemVerilog para una unidad aritmética y lógica (ALU) sencilla de 8 bits.

La ALU debe tener tres entradas: dos números de 8 bits llamados `a` y `b`, y un código de operación de 4 bits llamado `op`. Como salidas debe tener el resultado (`result`, 8 bits) y cuatro indicadores: `zero`, `carry`, `overflow` y `negative`.

Dependiendo del valor de `op`:
- op=0: suma a y b. Carry si se pasa de 8 bits.
- op=1: resta b de a. Carry si hay préstamo.
- op=2: AND bit a bit.
- op=3: OR bit a bit.
- op=4: XOR bit a bit.
- op=5: NOT de a (ignora b).
- op=6: shift left de a, bit saliente (a[7]) en carry.
- op=7: shift right de a, bit saliente (a[0]) en carry.
- op=8: si a < b (sin signo), result=1, si no result=0.
- op=9: multiplica nibbles bajos de a y b (a[3:0]*b[3:0]).
- otros: result=0, banderas=0.

Overflow solo aplica en suma y resta (complemento a 2).
Módulo: `alu`, combinacional, usar `always_comb`. Sin latches.""",

"alu_v3": """Genera un módulo SystemVerilog llamado `alu` basado en la siguiente tabla de comportamiento. ALU combinacional, 8 bits.

INTERFAZ:
Entradas: a[7:0], b[7:0], op[3:0]
Salidas:  result[7:0], zero, carry, overflow, negative

TABLA:
op | result              | zero  | carry  | overflow | negative
0  | a+b (8 bits bajos)  | r==0  | bit[8] | signo*   | r[7]
1  | a-b (8 bits bajos)  | r==0  | borrow | signo**  | r[7]
2  | a & b               | r==0  | 0      | 0        | r[7]
3  | a | b               | r==0  | 0      | 0        | r[7]
4  | a ^ b               | r==0  | 0      | 0        | r[7]
5  | ~a                  | r==0  | 0      | 0        | r[7]
6  | {a[6:0], 1'b0}      | r==0  | a[7]   | 0        | r[7]
7  | {1'b0, a[7:1]}      | r==0  | a[0]   | 0        | r[7]
8  | (a<b) ? 8'h01:8'h00 | r==0  | 0      | 0        | r[7]
9  | a[3:0] * b[3:0]     | r==0  | 0      | 0        | r[7]
F  | 8'h00               | 1     | 0      | 0        | 0

* overflow ADD = (~a[7]&~b[7]&r[7])|(a[7]&b[7]&~r[7])
** overflow SUB = (~a[7]&b[7]&r[7])|(a[7]&~b[7]&~r[7])

Usar case(op) en always_comb. Señales de 9 bits para suma/resta. Genera SOLO el módulo.""",

"alu_v4": """Implementa en SystemVerilog una ALU de 8 bits estilo RTL con estos bloques:

[1] UNIDAD ARITMÉTICA (op 0,1): sumador-restador 9 bits, carry en bit[8], overflow en complemento a 2.
[2] UNIDAD LÓGICA (op 2-5): AND, OR, XOR, NOT. Sin carry ni overflow.
[3] SHIFTER (op 6,7): SHL/SHR 1 posición, bit saliente en carry.
[4] COMPARADOR (op 8): SLT sin signo.
[5] MULTIPLICADOR (op 9): producto de nibbles bajos (4x4→8 bits).
[6] MUX FINAL: selecciona resultado según op con case().
[7] FLAGS: zero=(result==0), negative=result[7]. Carry y overflow solo en bloques correspondientes.

Módulo: alu. Puertos: a[7:0], b[7:0], op[3:0] (entradas); result[7:0], zero, carry, overflow, negative (salidas). Combinacional, always_comb, sin latches. Genera SOLO el módulo.""",

"alu_v5": """Necesito implementar una ALU de 8 bits en SystemVerilog. Sigue estos pasos:

PASO 1: Módulo `alu` con inputs a[7:0], b[7:0], op[3:0]; outputs result[7:0], zero, carry, overflow, negative.
PASO 2: always_comb, ADD (op=0): result=a+b, carry=bit[8]. SUB (op=1): result=a-b, carry=borrow.
PASO 3: AND(op=2), OR(op=3), XOR(op=4), NOT(op=5). Carry/overflow=0.
PASO 4: SHL(op=6): result=a<<1, carry=a[7]. SHR(op=7): result=a>>1, carry=a[0].
PASO 5: SLT(op=8): (a<b)?1:0. MUL(op=9): a[3:0]*b[3:0]. Default: todo=0.
PASO 6: zero=(result==0), negative=result[7]. Defaults para carry y overflow fuera de ops válidas.

Consolida en un módulo completo llamado `alu`, combinacional, sin latches. Genera SOLO el código.""",

# ═══════════════════════════════ Adder Tree ═══════════════════════════════════

"adder_tree_v1": """Implementa el siguiente componente RTL en SystemVerilog siguiendo la especificación técnica a continuación:

COMPONENTE: Adder Tree de 4 entradas, 8 bits. Nombre: adder_tree.
Tipo: Combinacional puro.
Puertos:
- in0 [7:0] input logic
- in1 [7:0] input logic
- in2 [7:0] input logic
- in3 [7:0] input logic
- sum [9:0] output logic — suma total (máx 4×255=1020, cabe en 10 bits)
- all_zero output logic — asertado si sum == 0

Arquitectura árbol en 2 niveles:
  Nivel 1: sum01 [8:0] = {1'b0, in0} + {1'b0, in1}
           sum23 [8:0] = {1'b0, in2} + {1'b0, in3}
  Nivel 2: sum [9:0]   = {1'b0, sum01} + {1'b0, sum23}
  Flag:    all_zero    = (sum == 10'h000)

Usar assign para todo (lógica puramente combinacional).
GENERA ÚNICAMENTE el módulo `adder_tree` completo.""",

"adder_tree_v2": """Quiero un módulo SystemVerilog llamado `adder_tree` que sume cuatro números de 8 bits usando una estructura de árbol.

Las entradas son in0, in1, in2, in3 (todas de 8 bits). Las salidas son sum (10 bits, para no perder precisión) y all_zero (1 bit, alto cuando la suma es cero).

La implementación debe hacerse en dos etapas: primero sumar in0+in1 e in2+in3 por separado, y luego sumar esos dos resultados intermedios. Esto evita la cadena de carry larga de una suma secuencial.

El módulo es completamente combinacional, sin reloj. Genera SOLO el código del módulo.""",

"adder_tree_v3": """Genera un módulo SystemVerilog `adder_tree` basado en:

SEÑALES:
  Entradas: in0[7:0], in1[7:0], in2[7:0], in3[7:0]
  Salidas:  sum[9:0], all_zero

COMPORTAMIENTO:
  sum      = in0 + in1 + in2 + in3  (10 bits para no overflow)
  all_zero = (sum == 10'd0)

IMPLEMENTACIÓN:
  wire [8:0] sum01 = {1'b0,in0} + {1'b0,in1};
  wire [8:0] sum23 = {1'b0,in2} + {1'b0,in3};
  assign sum = {1'b0,sum01} + {1'b0,sum23};
  assign all_zero = (sum == 10'h000);

Combinacional puro, sin always blocks. Genera SOLO el módulo.""",

"adder_tree_v4": """Implementa en SystemVerilog un adder tree de 4 entradas de 8 bits con estos bloques:

[1] SUMADOR NIVEL 1A: sum01[8:0] = in0 extendido + in1 extendido (9 bits, sin overflow).
[2] SUMADOR NIVEL 1B: sum23[8:0] = in2 extendido + in3 extendido.
[3] SUMADOR NIVEL 2:  sum[9:0]   = sum01 extendido + sum23 extendido (10 bits).
[4] FLAG: all_zero = (sum == 0).

Módulo: adder_tree. Combinacional puro (assign statements). Genera SOLO el módulo.""",

"adder_tree_v5": """Implementa un adder tree de 4 entradas en SystemVerilog siguiendo estos pasos:

PASO 1: Módulo `adder_tree`, inputs in0-in3[7:0], outputs sum[9:0] y all_zero.
PASO 2: Declarar logic[8:0] sum01, sum23.
PASO 3: assign sum01 = {1'b0,in0}+{1'b0,in1}; assign sum23 = {1'b0,in2}+{1'b0,in3};
PASO 4: assign sum = {1'b0,sum01}+{1'b0,sum23};
PASO 5: assign all_zero = (sum == 10'h000);

Genera SOLO el módulo completo en SystemVerilog.""",

# ═══════════════════════════════ FSM seq_det ══════════════════════════════════

"seq_det_v1": """Implementa el siguiente componente RTL en SystemVerilog:

COMPONENTE: Detector de Secuencia "1011", Moore, sincrónico. Nombre: seq_det.
Tipo: FSM de Moore, sincrónica con reset asíncrono activo-bajo.
Puertos:
- clk      input logic
- rst_n    input logic   — reset asíncrono, activo bajo
- data_in  input logic   — entrada serial
- detected output logic  — alto un ciclo cuando se detecta 1011

ESTADOS (5): IDLE(000), S1(001), S10(010), S101(011), S1011(100)
TRANSICIONES:
  IDLE:  d=0→IDLE,  d=1→S1
  S1:    d=0→S10,   d=1→S1
  S10:   d=0→IDLE,  d=1→S101
  S101:  d=0→S10,   d=1→S1011
  S1011: d=0→S10,   d=1→S1   (solapamiento)

SALIDA: detected = (state == S1011)

REQUISITOS: typedef enum, always_ff con reset asíncrono, always_comb para next_state, assign para detected. Genera SOLO el módulo.""",

"seq_det_v2": """Quiero un módulo SystemVerilog para un detector de secuencia serial "1011".

El módulo se llama `seq_det` y tiene: clk (reloj), rst_n (reset asíncrono activo en bajo), data_in (bit de entrada) y detected (salida, va a 1 por un ciclo cuando se detecta la secuencia).

La máquina de estados tiene 5 estados: IDLE, S1, S10, S101 y S1011. Cuando se detecta el patrón 1-0-1-1 en la entrada serial, detected se pone a 1. La secuencia es solapada: después de detectar 1011, si llega otro 1 puede ser el inicio de una nueva detección.

Usar typedef enum, always_ff para el registro de estado con reset asíncrono, y always_comb para la lógica de siguiente estado. Genera SOLO el módulo.""",

"seq_det_v3": """Genera módulo SystemVerilog `seq_det` basado en:

ESTADOS: IDLE(000)→det=0, S1(001)→0, S10(010)→0, S101(011)→0, S1011(100)→1

TRANSICIONES:
  IDLE:  d=0→IDLE,  d=1→S1
  S1:    d=0→S10,   d=1→S1
  S10:   d=0→IDLE,  d=1→S101
  S101:  d=0→S10,   d=1→S1011
  S1011: d=0→S10,   d=1→S1

PUERTOS: clk, rst_n (async low), data_in, detected (output)
CODIFICACIÓN: typedef enum logic[2:0], always_ff con negedge rst_n, always_comb para next_state.
SALIDA: assign detected = (state == S1011);
Genera SOLO el módulo.""",

"seq_det_v4": """Implementa en SystemVerilog un detector de secuencia 1011 con estos bloques:

[1] DEFINICIÓN: typedef enum logic[2:0] {IDLE,S1,S10,S101,S1011} state_t.
[2] REGISTROS: state_t state, next_state.
[3] FLIP-FLOP: always_ff @(posedge clk or negedge rst_n): reset asíncrono a IDLE.
[4] NEXT STATE: always_comb case(state): lógica de transición con solapamiento en S1011.
[5] SALIDA: assign detected = (state == S1011).

Módulo: seq_det. Puertos: clk, rst_n, data_in (inputs); detected (output logic). Genera SOLO el módulo.""",

"seq_det_v5": """Implementa un detector de secuencia 1011 en SystemVerilog siguiendo estos pasos:

PASO 1: Módulo `seq_det`: clk, rst_n, data_in (inputs), detected (output).
PASO 2: typedef enum logic[2:0] {IDLE,S1,S10,S101,S1011} state_t; state_t state, next_state.
PASO 3: always_ff @(posedge clk or negedge rst_n): if(!rst_n) state<=IDLE; else state<=next_state.
PASO 4: always_comb case(state): transiciones con solapamiento (S1011 + d=1 → S1).
PASO 5: assign detected = (state == S1011).

Genera SOLO el módulo completo.""",
}

# ─── Función de limpieza del output ───────────────────────────────────────────

def clean_output(text: str) -> str:
    """
    Extrae SOLO el bloque de código SystemVerilog de la respuesta del modelo.
    Elimina explicaciones, markdown, texto extra, etc.
    """
    # Intentar extraer bloque ```verilog / ```systemverilog / ```
    import re
    patterns = [
        r'```(?:systemverilog|verilog|sv|hdl)\s*\n(.*?)```',
        r'```\s*\n(.*?)```',
    ]
    for pat in patterns:
        m = re.search(pat, text, re.DOTALL | re.IGNORECASE)
        if m:
            return m.group(1).strip()

    # Si no hay markdown, buscar desde "module" hasta "endmodule"
    m = re.search(r'(`timescale\s+.*?\n)?(module\s+\w+.*?endmodule)', text, re.DOTALL)
    if m:
        return m.group(0).strip()

    # Fallback: devolver todo (puede que el modelo devuelva código limpio)
    return text.strip()


# ─── Backend: HuggingFace transformers ────────────────────────────────────────

def run_hf(prompts: dict, output_dir: str):
    from transformers import AutoTokenizer, AutoModelForCausalLM
    import torch

    print(f"\n📦 Cargando modelo: {HF_MODEL_ID}")
    print("   (primera vez puede tardar varios minutos descargando ~7GB)\n")

    tokenizer = AutoTokenizer.from_pretrained(HF_MODEL_ID)
    model = AutoModelForCausalLM.from_pretrained(
        HF_MODEL_ID,
        torch_dtype=torch.float16,
        device_map="auto",           # usa GPU si está disponible
        load_in_8bit=True,           # cuantización 8-bit para ahorrar VRAM
    )
    model.eval()

    for name, prompt in prompts.items():
        print(f"⚙️  Generando: {name} ...", end="", flush=True)
        t0 = time.time()

        inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=MAX_NEW_TOKENS,
                temperature=TEMPERATURE,
                top_p=TOP_P,
                do_sample=DO_SAMPLE,
                pad_token_id=tokenizer.eos_token_id,
            )

        # Decodificar solo los tokens nuevos (no el prompt)
        new_tokens = outputs[0][inputs["input_ids"].shape[1]:]
        raw_text = tokenizer.decode(new_tokens, skip_special_tokens=True)

        code = clean_output(raw_text)
        save_file(name, code, output_dir)
        print(f" ✓  ({time.time()-t0:.1f}s)")

    print(f"\n✅ Generación completada. Archivos en: {output_dir}/")


# ─── Backend: LM Studio (OpenAI-compatible API) ───────────────────────────────

def run_lmstudio(prompts: dict, output_dir: str, base_url: str = "http://localhost:1234"):
    """
    LM Studio expone una API compatible con OpenAI en http://localhost:1234/v1
    Solo necesitas: pip install openai
    """
    try:
        from openai import OpenAI
    except ImportError:
        print("ERROR: instala el cliente: pip install openai")
        sys.exit(1)

    client = OpenAI(base_url=f"{base_url}/v1", api_key="lm-studio")

    # Verificar que el servidor esté activo
    try:
        models = client.models.list()
        model_id = models.data[0].id if models.data else "local-model"
        print(f"\n📦 LM Studio activo — modelo cargado: {model_id}\n")
    except Exception as e:
        print(f"ERROR: No se puede conectar a LM Studio en {base_url}")
        print(f"  → Asegúrate de tener el servidor activo (pestaña 'Local Server' → Start)")
        print(f"  → Detalle: {e}")
        sys.exit(1)

    for name, prompt in prompts.items():
        print(f"⚙️  Generando: {name} ...", end="", flush=True)
        t0 = time.time()

        response = client.chat.completions.create(
            model=model_id,
            messages=[
                {"role": "system", "content": "You are an expert RTL hardware designer. Generate only clean, synthesizable SystemVerilog code with no explanations."},
                {"role": "user",   "content": prompt},
            ],
            temperature=TEMPERATURE,
            max_tokens=MAX_NEW_TOKENS,
            top_p=TOP_P,
        )

        raw_text = response.choices[0].message.content or ""
        code = clean_output(raw_text)
        save_file(name, code, output_dir)
        print(f" ✓  ({time.time()-t0:.1f}s)")

    print(f"\n✅ Generación completada. Archivos en: {output_dir}/")


# ─── Backend: Ollama ──────────────────────────────────────────────────────────

def run_ollama(prompts: dict, output_dir: str, model_name: str = "rtlcoder"):
    import subprocess, json

    print(f"\n📦 Usando Ollama con modelo: {model_name}\n")

    for name, prompt in prompts.items():
        print(f"⚙️  Generando: {name} ...", end="", flush=True)
        t0 = time.time()

        payload = json.dumps({"model": model_name, "prompt": prompt, "stream": False,
                              "options": {"temperature": TEMPERATURE, "top_p": TOP_P,
                                          "num_predict": MAX_NEW_TOKENS}})
        result = subprocess.run(
            ["curl", "-s", "-X", "POST", "http://localhost:11434/api/generate",
             "-H", "Content-Type: application/json", "-d", payload],
            capture_output=True, text=True
        )

        try:
            response = json.loads(result.stdout)
            raw_text = response.get("response", "")
        except Exception as e:
            raw_text = f"// ERROR al parsear respuesta de Ollama: {e}"

        code = clean_output(raw_text)
        save_file(name, code, output_dir)
        print(f" ✓  ({time.time()-t0:.1f}s)")

    print(f"\n✅ Generación completada. Archivos en: {output_dir}/")


# ─── Guardar archivo ──────────────────────────────────────────────────────────

def save_file(name: str, code: str, output_dir: str):
    """Guarda el código con saltos de línea Unix y verifica que no esté corrupto."""
    os.makedirs(output_dir, exist_ok=True)
    filepath = os.path.join(output_dir, f"{name}.sv")

    # Normalizar saltos de línea a Unix (\n)
    code = code.replace("\r\n", "\n").replace("\r", "\n")

    with open(filepath, "w", encoding="utf-8", newline="\n") as f:
        f.write(code)
        if not code.endswith("\n"):
            f.write("\n")

    # Verificación básica
    lines = code.split("\n")
    has_module = "module" in code
    has_end    = "endmodule" in code
    status = "✓" if (has_module and has_end) else "⚠ (sin module/endmodule)"
    print(f"   → {filepath}  [{len(lines)} líneas] {status}")


# ─── Main ─────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Regenerar archivos RTLCoder para benchmark")
    parser.add_argument("--model", choices=["lmstudio", "hf", "ollama"], default="lmstudio",
                        help="Backend: 'lmstudio' (default), 'hf' (HuggingFace) o 'ollama'")
    parser.add_argument("--ollama-model", default="rtlcoder",
                        help="Nombre del modelo en Ollama (default: rtlcoder)")
    parser.add_argument("--hf-model", default=HF_MODEL_ID,
                        help=f"Model ID en HuggingFace (default: {HF_MODEL_ID})")
    parser.add_argument("--output", default=OUTPUT_DIR,
                        help=f"Carpeta de salida (default: {OUTPUT_DIR})")
    parser.add_argument("--circuit", choices=["alu", "adder_tree", "seq_det", "all"],
                        default="all", help="Qué circuito generar (default: all)")
    args = parser.parse_args()

    # Filtrar prompts si se especifica un circuito
    selected = {k: v for k, v in PROMPTS.items()
                if args.circuit == "all" or k.startswith(args.circuit)}

    print(f"🔧 RTLCoder Benchmark — Re-generación de código HDL")
    print(f"   Prompts seleccionados: {len(selected)}")
    print(f"   Carpeta de salida:     {args.output}")
    print(f"   Backend:               {args.model}")

    if args.model == "lmstudio":
        run_lmstudio(selected, args.output)
    elif args.model == "hf":
        HF_MODEL_ID = args.hf_model
        run_hf(selected, args.output)
    else:
        run_ollama(selected, args.output, args.ollama_model)
