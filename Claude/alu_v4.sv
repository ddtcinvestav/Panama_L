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

    // ----------------------------------------------------------------
    // [1] UNIDAD ARITMÉTICA — sumador/restador de 9 bits
    // ----------------------------------------------------------------
    logic [8:0] arith_result;
    logic       arith_carry;
    logic       arith_overflow;

    always_comb begin
        case (op)
            4'h0: arith_result = {1'b0, a} + {1'b0, b};   // ADD
            4'h1: arith_result = {1'b0, a} - {1'b0, b};   // SUB
            default: arith_result = 9'h000;
        endcase

        arith_carry = arith_result[8];

        case (op)
            4'h0: arith_overflow = (~a[7] & ~b[7] &  arith_result[7]) |
                                   ( a[7] &  b[7] & ~arith_result[7]);
            4'h1: arith_overflow = (~a[7] &  b[7] &  arith_result[7]) |
                                   ( a[7] & ~b[7] & ~arith_result[7]);
            default: arith_overflow = 1'b0;
        endcase
    end

    // ----------------------------------------------------------------
    // [2] UNIDAD LÓGICA — AND, OR, XOR, NOT
    // ----------------------------------------------------------------
    logic [7:0] logic_result;

    always_comb begin
        case (op)
            4'h2:    logic_result = a & b;
            4'h3:    logic_result = a | b;
            4'h4:    logic_result = a ^ b;
            4'h5:    logic_result = ~a;
            default: logic_result = 8'h00;
        endcase
    end

    // ----------------------------------------------------------------
    // [3] SHIFTER — SHL / SHR, bit saliente en carry
    // ----------------------------------------------------------------
    logic [7:0] shift_result;
    logic       shift_carry;

    always_comb begin
        case (op)
            4'h6: begin
                shift_result = {a[6:0], 1'b0};   // SHL
                shift_carry  = a[7];
            end
            4'h7: begin
                shift_result = {1'b0, a[7:1]};   // SHR
                shift_carry  = a[0];
            end
            default: begin
                shift_result = 8'h00;
                shift_carry  = 1'b0;
            end
        endcase
    end

    // ----------------------------------------------------------------
    // [4] COMPARADOR — SLT sin signo
    // ----------------------------------------------------------------
    logic [7:0] cmp_result;

    always_comb
        cmp_result = (a < b) ? 8'h01 : 8'h00;

    // ----------------------------------------------------------------
    // [5] MULTIPLICADOR — nibbles bajos, producto de 8 bits
    // ----------------------------------------------------------------
    logic [7:0] mul_result;

    always_comb
        mul_result = {a[3:0] * b[3:0]};

    // ----------------------------------------------------------------
    // [6] MUX DE SALIDA — selección de bloque por op
    // ----------------------------------------------------------------
    logic [7:0] mux_result;
    logic       mux_carry;
    logic       mux_overflow;

    always_comb begin
        // Defaults (NOP / opcodes no definidos)
        mux_result   = 8'h00;
        mux_carry    = 1'b0;
        mux_overflow = 1'b0;

        case (op)
            // Aritmética
            4'h0,
            4'h1: begin
                mux_result   = arith_result[7:0];
                mux_carry    = arith_carry;
                mux_overflow = arith_overflow;
            end
            // Lógica
            4'h2,
            4'h3,
            4'h4,
            4'h5: begin
                mux_result   = logic_result;
                mux_carry    = 1'b0;
                mux_overflow = 1'b0;
            end
            // Shifter
            4'h6,
            4'h7: begin
                mux_result   = shift_result;
                mux_carry    = shift_carry;
                mux_overflow = 1'b0;
            end
            // Comparador
            4'h8: begin
                mux_result   = cmp_result;
                mux_carry    = 1'b0;
                mux_overflow = 1'b0;
            end
            // Multiplicador
            4'h9: begin
                mux_result   = mul_result;
                mux_carry    = 1'b0;
                mux_overflow = 1'b0;
            end
            default: begin
                mux_result   = 8'h00;
                mux_carry    = 1'b0;
                mux_overflow = 1'b0;
            end
        endcase
    end

    // ----------------------------------------------------------------
    // [7] FLAGS — derivados del resultado del MUX
    // ----------------------------------------------------------------
    assign result   = mux_result;
    assign carry    = mux_carry;
    assign overflow = mux_overflow;
    assign zero     = (mux_result == 8'h00);
    assign negative = mux_result[7];

endmodule