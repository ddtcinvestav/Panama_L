module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry,
    output logic       overflow,
    output logic       negative
);

    logic [8:0] tmp;

    always_comb begin
        // Inicialización para evitar latches
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        case (op)
            4'h0: begin // ADD
                tmp      = a + b;
                result   = tmp[7:0];
                carry    = tmp[8];
                overflow = (~a[7] & ~b[7] & result[7]) |
                           ( a[7] &  b[7] & ~result[7]);
            end

            4'h1: begin // SUB
                tmp      = a - b;
                result   = tmp[7:0];
                carry    = tmp[8]; // borrow
                overflow = (~a[7] &  b[7] & result[7]) |
                           ( a[7] & ~b[7] & ~result[7]);
            end

            4'h2: result = a & b;            // AND
            4'h3: result = a | b;            // OR
            4'h4: result = a ^ b;            // XOR
            4'h5: result = ~a;               // NOT

            4'h6: begin // SHL
                result = a << 1;
                carry  = a[7];
            end

            4'h7: begin // SHR
                result = a >> 1;
                carry  = a[0];
            end

            4'h8: result = (a < b) ? 8'h01 : 8'h00; // SLT (unsigned)

            4'h9: result = a[3:0] * b[3:0]; // MUL (4x4)

            default: begin
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase

        // Banderas comunes
        zero     = (result == 8'h00);
        negative = result[7];
    end

endmodule