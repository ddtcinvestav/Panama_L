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

    logic [8:0] add_ext;
    logic [8:0] sub_ext;

    always_comb begin
        // Valores por defecto (evita latches)
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        add_ext  = 9'h000;
        sub_ext  = 9'h000;

        case (op)
            4'h0: begin // ADD
                add_ext  = a + b;
                result   = add_ext[7:0];
                carry    = add_ext[8];
                overflow = (~a[7] & ~b[7] & result[7]) |
                           ( a[7] &  b[7] & ~result[7]);
            end

            4'h1: begin // SUB
                sub_ext  = a - b;
                result   = sub_ext[7:0];
                carry    = sub_ext[8]; // borrow
                overflow = (~a[7] &  b[7] & result[7]) |
                           ( a[7] & ~b[7] & ~result[7]);
            end

            4'h2: result = a & b; // AND
            4'h3: result = a | b; // OR
            4'h4: result = a ^ b; // XOR
            4'h5: result = ~a;    // NOT

            4'h6: begin // SHL
                result = {a[6:0], 1'b0};
                carry  = a[7];
            end

            4'h7: begin // SHR
                result = {1'b0, a[7:1]};
                carry  = a[0];
            end

            4'h8: result = (a < b) ? 8'h01 : 8'h00; // SLT (unsigned)

            4'h9: result = a[3:0] * b[3:0]; // MUL (4x4)

            4'hF: begin // NOP explícito
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end

            default: begin
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase

        // Banderas comunes
        zero     = (result == 8'h00);
        negative = result[7];

        // Caso especial op = F (forzar flags)
        if (op == 4'hF) begin
            zero     = 1'b1;
            negative = 1'b0;
        end
    end

endmodule