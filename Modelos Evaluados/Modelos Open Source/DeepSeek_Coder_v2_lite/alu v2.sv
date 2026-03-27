module alu (
    input        [7:0] a,
    input        [7:0] b,
    input        [3:0] op,
    output       [7:0] result,
    output        zero,
    output        carry,
    output        overflow,
    output        negative
);

logic [7:0] result_internal;
logic zero_internal;
logic carry;
logic overflow;
logic negative;

always_comb begin
    case (op)
        4'b0000: result_internal = a + b; // ADD
        4'b0001: result_internal = a - b; // SUB
        4'b0010: result_internal = a & b; // AND
        4'b0011: result_internal = a | b; // OR
        4'b0100: result_internal = a ^ b; // XOR
        4'b0101: result_internal = ~a; // NOT
        4'b0110: result_internal = (a << 1); // SHL
        4'b0111: result_internal = (a >> 1); // SHR
        4'b1000: result_internal = (a < b) ? 8'h01 : 8'h00; // SLT
        4'b1001: result_internal = a[3:0] * b[3:0]; // Mul nibbles
        default: result_internal = 8'h00;
    endcase
end

assign zero = (result == 8'h00);
assign carry = overflow; // Carry only applies to ADD and SUB
assign negative = result[7];

endmodule