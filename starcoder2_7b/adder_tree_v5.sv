`timescale 1ns/1ps

module adder_tree(in0, in1, in2, in3, sum, all_zero);
input [7:0] in0, in1, in2, in3;
output [9:0] sum;
output all_zero;

logic [8:0] sum01, sum23;
assign sum01 = {1'b0, in0} + {1'b0, in1};
assign sum23 = {1'b0, in2} + {1'b0, in3};
assign sum = {1'b0, sum01} + {1'b0, sum23};
assign all_zero = (sum == 10'h000);
endmodule