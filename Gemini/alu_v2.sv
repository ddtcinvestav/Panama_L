// Módulo: alu
// Descripción: Unidad Aritmética y Lógica de 8 bits
// Estándar: IEEE 1800-2017

module alu (
    input  logic [7:0] a,        // Operando A
    input  logic [7:0] b,        // Operando B
    input  logic [3:0] op,       // Código de operación
    output logic [7:0] result,   // Resultado de la operación
    output logic       zero,     // Indicador: result == 0
    output logic       carry,    // Indicador: Acarreo/Préstamo/Bit desplazado
    output logic       overflow, // Indicador: Desbordamiento en complemento a 2
    output logic       negative  // Indicador: Bit de signo (result[7])
);

    // Lógica principal de la ALU
    always_comb begin
        // Valores por defecto para evitar latches
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        case (op)
            // Aritmética
            4'h0: begin // SUMA
                {carry, result} = a + b;
                // V = (A7 == B7) && (A7 != R7)
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end
            
            4'h1: begin // RESTA (a - b)
                {carry, result} = a - b;
                // V = (A7 != B7) && (A7 != R7)
                overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
            end

            // Lógica
            4'h2: result = a & b; // AND
            4'h3: result = a | b; // OR
            4'h4: result = a ^ b; // XOR
            4'h5: result = ~a;    // NOT

            // Desplazamientos
            4'h6: begin // SHL (Shift Left)
                carry  = a[7];
                result = a << 1;
            end
            
            4'h7: begin // SHR (Shift Right)
                carry  = a[0];
                result = a >> 1;
            end

            // Comparación
            4'h8: result = (a < b) ? 8'h01 : 8'h00; // SLT (Set Less Than)

            // Multiplicación de nibbles
            4'h9: result = a[3:0] * b[3:0];

            // NOP / Otros
            default: begin
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    // Asignación continua de banderas de estado
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule