// Módulo: alu (8 bits, combinacional)
// Basado en la especificación técnica de tabla de comportamiento

module alu (
    input  logic [7:0] a,        // Operando A
    input  logic [7:0] b,        // Operando B
    input  logic [3:0] op,       // Código de operación
    output logic [7:0] result,   // Resultado
    output logic       zero,     // Indicador de resultado cero
    output logic       carry,    // Indicador de acarreo/préstamo/desplazamiento
    output logic       overflow, // Indicador de desbordamiento (complemento a 2)
    output logic       negative  // Indicador de bit de signo (MSB)
);

    // Señal intermedia de 9 bits para cálculos de suma y resta
    logic [8:0] math_res;

    always_comb begin
        // Valores por defecto para evitar latches
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;
        math_res = 9'h000;

        case (op)
            4'h0: begin // ADD: a + b
                math_res = a + b;
                result   = math_res[7:0];
                carry    = math_res[8];
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end

            4'h1: begin // SUB: a - b
                math_res = a - b;
                result   = math_res[7:0];
                carry    = math_res[8];
                overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
            end

            4'h2: begin // AND
                result = a & b;
            end

            4'h3: begin // OR
                result = a | b;
            end

            4'h4: begin // XOR
                result = a ^ b;
            end

            4'h5: begin // NOT
                result = ~a;
            end

            4'h6: begin // SHL: {a[6:0], 1'b0}
                result = {a[6:0], 1'b0};
                carry  = a[7];
            end

            4'h7: begin // SHR: {1'b0, a[7:1]}
                result = {1'b0, a[7:1]};
                carry  = a[0];
            end

            4'h8: begin // SLT: (a < b)
                result = (a < b) ? 8'h01 : 8'h00;
            end

            4'h9: begin // MUL: nibbles bajos
                result = a[3:0] * b[3:0];
            end

            4'hF: begin // RESET/CLEAR: 8'h00
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end

            default: begin // Otros casos
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    // Lógica de banderas de salida
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule