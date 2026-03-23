`timescale 1ns/1ps

COMPONENTE: Arithmetic Logic Unit (ALU)
VERSIÓN: 1.0
ESTÁNDAR: IEEE 1800-2017 (SystemVerilog)
1. DECLARACIÓN DEL MÓDULO
   Nombre: alu
   Tipo: Combinacional (sin reloj, sin reset)
   Puertos:
     - a        [7:0]  input  logic  — Operando A (sin signo)
     - b        [7:0]  input  logic  — Operando B (sin signo)
     - op       [3:0]  input  logic  — Selector de operación
     - result   [7:0]  output logic  — Resultado de la operación
     - zero            output logic  — Asertado cuando result == 0
     - carry           output logic  — Carry/borrow en operaciones aritméticas
     - overflow        output logic  — Desbordamiento en complemento a 2
     - negative        output logic  — Igual a result[7]

2. TABLA DE OPERACIONES
   op=4'h0  ADD:  result = a + b; carry = bit[8]
   op=4'h1  SUB:  result = a - b; carry = borrow
   op=4'h2  AND:  result = a & b
   op=4'h3  OR:   result = a | b
   op=4'h4  XOR:  result = a ^ b
   op=4'h5  NOT:  result = ~a
   op=4'h6  SHL:  result = a << 1; carry = a[7]
   op=4'h7  SHR:  result = a >> 1; carry = a[0]
   op=4'h8  SLT:  result = (a < b) ? 8'h01 : 8'h00
   op=4'h9  MUL:  result = a[3:0] * b[3:0] (8 bits)
   otros    NOP:  result = 0, todas las banderas = 0

3. LÓGICA DE BANDERAS
   zero     = (result == 8'h00)
   carry    = solo activo en ADD, SUB, SHL, SHR
   overflow = solo activo en ADD y SUB
              ADD: (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7])
              SUB: (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7])
              SHL: (~a[7] & b[7] & result[7]) | (a[7] & b[7] & ~result[7])
              SHR: (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7])
              MUL: (a[3:0] * b[3:0])
              otros    NOP:  result = 0, todas las banderas = 0

4. REQUISITOS DE CODIFICACIÓN
   - Usar always_comb (no always @(*))
   - No se permiten latches inferidos
   - Código 100% sintetizable
   - No usar imports de paquetes externos

GENERA ÚNICAMENTE el módulo `alu` completo y funcional.