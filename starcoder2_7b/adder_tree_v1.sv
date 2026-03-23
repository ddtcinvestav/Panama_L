`timescale 1ns/1ps

module adder_tree(input [7:0] in0, in1, in2, in3, output [9:0] sum, output all_zero);

assign sum = {1'b0,in0}+{1'b0,in1}+{1'b0,in2}+{1'b0,in3};
assign all_zero = (sum==10'h000);

endmodule