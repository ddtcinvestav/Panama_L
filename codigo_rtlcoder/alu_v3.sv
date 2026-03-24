module alu (a, b, op, result, zero, carry, overflow, negative);
input [7:0] a, b;
input [3:0] op;
output [7:0] result;
output zero, carry, overflow, negative;

assign {carry, overflow} = 2'b00;
assign negative = (result[7] == 1);
assign zero = (result == 8'h00);

always_comb begin
case (op)
4'h0: result = a + b;
4'h1: result = a - b;
4'h2: result = a & b;
4'h3: result = a | b;
4'h4: result = a ^ b;
4'h5: result = ~a;
4'h6: result = {1'b0, a[7:1]};
4'h7: result = {a[0], a[7:1]};
4'h8: result = (a < b) ? 9'h1 : 9'h0;
4'h9: result = (a[3:0] * b[3:0]) % 2;
default: result = 8'h00;
endcase

if (op == 4'h0) begin
  carry = a[7] ^ b[7];
  overflow = (a[6] & b[6]) | (~a[6] & ~b[6]);
end else if (op == 4'h1) begin
  carry = a[7] ^ b[7];
  overflow = (~a[6] & b[6]) | (a[6] & ~b[6]);
end else if (op == 4'h6) begin
  carry = a[7];
end else if (op == 4'h7) begin
  carry = a[0];
end else if (op == 4'h8) begin
  overflow = (a < b);
end else if (op == 4'h9) begin
  overflow = (result > 8'hFF);
end
end
endmodule