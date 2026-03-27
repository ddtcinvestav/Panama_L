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

    // [1] UNIDAD ARITMÉTICA
    logic [8:0] add_ext, sub_ext;
    logic [7:0] arith_res;
    logic       arith_carry, arith_overflow;

    // [2] UNIDAD LÓGICA
    logic [7:0] logic_res;

    // [3] SHIFTER
    logic [7:0] shift_res;
    logic       shift_carry;

    // [4] COMPARADOR
    logic [7:0] comp_res;

    // [5] MULTIPLICADOR
    logic [7:0] mult_res;

    always_comb begin
        // =========================
        // Defaults globales
        // =========================
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        // =========================
        // [1] ARITHMETIC UNIT
        // =========================
        add_ext = a + b;
        sub_ext = a - b;

        arith_res      = 8'h00;
        arith_carry    = 1'b0;
        arith_overflow = 1'b0;

        case (op)
            4'h0: begin // ADD
                arith_res      = add_ext[7:0];
                arith_carry    = add_ext[8];
                arith_overflow = (~a[7] & ~b[7] & arith_res[7]) |
                                 ( a[7] &  b[7] & ~arith_res[7]);
            end

            4'h1: begin // SUB
                arith_res      = sub_ext[7:0];
                arith_carry    = sub_ext[8]; // borrow
                arith_overflow = (~a[7] &  b[7] & arith_res[7]) |
                                 ( a[7] & ~b[7] & ~arith_res[7]);
            end

            default: begin
                arith_res      = 8'h00;
                arith_carry    = 1'b0;
                arith_overflow = 1'b0;
            end
        endcase

        // =========================
        // [2] LOGIC UNIT
        // =========================
        case (op)
            4'h2: logic_res = a & b;
            4'h3: logic_res = a | b;
            4'h4: logic_res = a ^ b;
            4'h5: logic_res = ~a;
            default: logic_res = 8'h00;
        endcase

        // =========================
        // [3] SHIFTER
        // =========================
        shift_res   = 8'h00;
        shift_carry = 1'b0;

        case (op)
            4'h6: begin // SHL
                shift_res   = {a[6:0], 1'b0};
                shift_carry = a[7];
            end

            4'h7: begin // SHR
                shift_res   = {1'b0, a[7:1]};
                shift_carry = a[0];
            end

            default: begin
                shift_res   = 8'h00;
                shift_carry = 1'b0;
            end
        endcase

        // =========================
        // [4] COMPARATOR
        // =========================
        comp_res = (a < b) ? 8'h01 : 8'h00;

        // =========================
        // [5] MULTIPLIER
        // =========================
        mult_res = a[3:0] * b[3:0];

        // =========================
        // [6] OUTPUT MUX
        // =========================
        case (op)
            4'h0,
            4'h1: begin
                result   = arith_res;
                carry    = arith_carry;
                overflow = arith_overflow;
            end

            4'h2,
            4'h3,
            4'h4,
            4'h5: begin
                result = logic_res;
            end

            4'h6,
            4'h7: begin
                result = shift_res;
                carry  = shift_carry;
            end

            4'h8: begin
                result = comp_res;
            end

            4'h9: begin
                result = mult_res;
            end

            default: begin
                result   = 8'h00;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase

        // =========================
        // [7] FLAGS
        // =========================
        zero     = (result == 8'h00);
        negative = result[7];
    end

endmodule