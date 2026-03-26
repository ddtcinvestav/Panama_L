// COMPONENTE: Arithmetic Logic Unit (ALU)
// VERSIÓN: 1.0
// ESTÁNDAR: IEEE 1800-2017

module alu (
    input  logic [7:0] a,        // Operando A
    input  logic [7:0] b,        // Operando B
    input  logic [3:0] op,       // Selector de operación
    output logic [7:0] result,   // Resultado
    output logic       zero,     // Flag: Resultado es cero
    output logic       carry,    // Flag: Carry/Borrow
    output logic       overflow, // Flag: Desbordamiento complemento a 2
    output logic       negative  // Flag: Resultado negativo (MSB)
);

    // Bloque combinacional principal
    always_comb begin
        // Valores por defecto para evitar la inferencia de latches
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        case (op)
            4'h0: begin // ADD
                {carry, result} = a + b;
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end
            
            4'h1: begin // SUB
                {carry, result} = a - b;
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
            
            4'h6: begin // SHL
                carry  = a[7];
                result = a << 1;
            end
            
            4'h7: begin // SHR
                carry  = a[0];
                result = a >> 1;
            end
            
            4'h8: begin // SLT (Set Less Than)
                result = (a < b) ? 8'h01 : 8'h00;
            end
            
            4'h9: begin // MUL (4-bit x 4-bit)
                result = a[3:0] * b[3:0];
            end

            default: begin // NOP / Otros
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    // Lógica de banderas de salida (dependientes del resultado final)
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule