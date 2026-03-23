module alu (
    input        [7:0] a,
    input        [7:0] b,
    input        [3:0] op,
    output logic [7:0] result,
    output       zero,
    output       carry,
    output       overflow,
    output       negative
);

logic [8:0] r; // 9 bits for sum/difference with possible overflow
logic sign_a, sign_b;

always_comb begin
    case (op)
        4'b0000: result = a + b; // ADD
        4'b0001: result = a - b; // SUB
        4'b0010: result = a & b; // AND
        4'b0011: result = a | b; // OR
        4'b0100: result = a ^ b; // XOR
        4'b0101: result = ~a; // NOT
        4'b0110: result = (a << 1); // SHL
        4'b0111: result = (a >> 1); // SHR
        4'b1000: result = (a < b) ? 8'h01 : 8'h00; // SLT
        4'b1001: result = a[3:0] * b[3:0]; // Mul nibbles
        default: result = 8'h00;
    endcase
end

assign zero = (result == 8'h00);
assign carry = r[8]; // Overflow occurs in ADD/SUB, not applicable for AND/OR/XOR/NOT
assign overflow = ((a[7] && b[7] && ~(r[7])) || (!(a[7] && ~b[7] && r[7])); // XOR operation doesn't affect overflow but other operations might need to be checked manually
assign negative = result[7];

endmodule