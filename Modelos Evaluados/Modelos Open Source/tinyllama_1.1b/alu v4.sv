`timescale 1ns/1ps

En SystemVerilog, una ALU de 8 bits está diseñada como un bloque de 8 líneas de código, con los siguientes bloques:

1. UNIDAD ARITMÉTICA (op 0,1): sumador-restador 9 bits, carry en bit[8], overflow en complemento a 2.

2. UNIDAD LÓGICA (op 2-5): AND, OR, XOR, NOT. Sin carry ni overflow.

3. SHIFTER (op 6,7): SHL/SHR 1 posición, bit saliente en carry.

4. COMPARADOR (op 8): a<b → 8'h01, else 8'h00.

5. MULTIPLICADOR (op 9): a[3:0]*b[3:0], 8 bits.

6. MUX SALIDA: selecciona bloque por op.

7. FLAGS: zero=(r==0), negative=r[7], carry y overflow según operación.

En el código, se utiliza la sintaxis de SystemVerilog para definir los bloques de la ALU. Además, se utiliza la sintaxis de combinacional para definir la interfaz de la ALU.

En el código, se define la interfaz de la ALU como un module alu, que contiene los bloques de la ALU. El código también define la interfaz de entrada y salida de la ALU, que se utilizan para comunicar con el resto del sistema.

El código generado por el programa de Synthesis es el código de la ALU de 8 bits.