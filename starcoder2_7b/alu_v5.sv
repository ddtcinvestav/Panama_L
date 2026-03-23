`timescale 1ns/1ps

module alu(input [7:0]a,input [7:0]b,input [3:0]op,output [7:0]result,output zero,output carry,output overflow,output negative);
always_comb begin
case(op)
0: result=a+b;
1: result=a-b;
2: result=a&b;
3: result=a|b;
4: result=a^b;
5: result=~a;
6: result=a<<1;
7: result=a>>1;
8: result=a<b?1:0;
9: result=a[3:0]*b[3:0];
default: result=0;
endcase
end
assign zero=result==0;
assign negative=result[7];
endmodule