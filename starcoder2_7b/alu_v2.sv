`timescale 1ns/1ps

module alu(input [7:0] a, b, op, output [7:0] result, output zero, output carry, output overflow, output negative);

always_comb begin
case(op)
0: result = a + b;
1: result = a - b;
2: result = a & b;
3: result = a | b;
4: result = a ^ b;
5: result = ~a;
6: result = a << 1;
7: result = a >> 1;
8: result = a < b? 1 : 0;
9: result = a * b;
default: result = 0;
endcase

zero = result == 0;
carry = result[8];
overflow = (a[7] == b[7] && a[7]!= result[7]) || (a[7]!= b[7] && a[7] == result[7]);
negative = result[7];
endmodule