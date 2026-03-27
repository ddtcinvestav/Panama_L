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

    logic [8:0] temp_add;
    logic [8:0] temp_sub;

    always_comb begin
        // Valores por defecto
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        temp_add = 9'h000;
        temp_sub = 9'h000;

        case (op)
            4'h0: begin // ADD
                temp_add = a + b;
                result   = temp_add[7:0];
                carry    = temp_add[8];
                overflow = (~a[7] & ~b[7] & result[7]) |
                           ( a[7] &  b[7] & ~result[7]);
            end

            4'h1: begin // SUB
                temp_sub = a - b;
                result   = temp_sub[7:0];
                carry    = temp_sub[8]; // borrow
                overflow = (~a[7] &  b[7] & result[7]) |
                           ( a[7] & ~b[7] & ~result[7]);
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
                result = a << 1;
                carry  = a[7];
            end

            4'h7: begin // SHR
                result = a >> 1;
                carry  = a[0];
            end

            4'h8: begin // SLT
                result = (a < b) ? 8'h01 : 8'h00;
            end

            4'h9: begin // MUL (4x4)
                result = a[3:0] * b[3:0];
            end

            default: begin // NOP
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