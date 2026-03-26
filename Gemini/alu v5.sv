// COMPONENTE: alu
// ESTÁNDAR: IEEE 1800-2017 (SystemVerilog)
// TIPO: Combinacional puro (sin latches)

module alu (
    input  logic [7:0] a,        // PASO 1: Entradas
    input  logic [7:0] b,
    input  logic [3:0] op,
    output logic [7:0] result,   // PASO 1: Salidas
    output logic       zero,
    output logic       carry,
    output logic       overflow,
    output logic       negative
);

    // Señal intermedia para capturar el bit 8 (carry/borrow)
    logic [8:0] full_res;

    // Bloque combinacional principal
    always_comb begin
        // PASO 6: Valores por defecto para evitar latches y limpiar banderas
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;
        full_res = 9'h000;

        case (op)
            // PASO 2: Aritmética (ADD y SUB)
            4'h0: begin // ADD
                full_res = a + b;
                result   = full_res[7:0];
                carry    = full_res[8];
                // V = (A7 == B7) && (A7 != R7)
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end

            4'h1: begin // SUB
                full_res = a - b;
                result   = full_res[7:0];
                carry    = full_res[8];
                // V = (A7 != B7) && (A7 != R7)
                overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
            end

            // PASO 3: Lógica (Banderas carry/overflow ya están en 0 por defecto)
            4'h2: result = a & b; // AND
            4'h3: result = a | b; // OR
            4'h4: result = a ^ b; // XOR
            4'h5: result = ~a;    // NOT (Ignora b)

            // PASO 4: Shifters
            4'h6: begin // SHL
                result = {a[6:0], 1'b0};
                carry  = a[7];
            end
            
            4'h7: begin // SHR
                result = {1'b0, a[7:1]};
                carry  = a[0];
            end

            // PASO 5: Operaciones Especiales
            4'h8: result = (a < b) ? 8'h01 : 8'h00; // SLT (Set Less Than)
            4'h9: result = a[3:0] * b[3:0];         // MUL (Nibbles bajos)

            // PASO 5: Default (Result=0)
            default: begin
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    // PASO 6: Lógica de banderas de estado
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule