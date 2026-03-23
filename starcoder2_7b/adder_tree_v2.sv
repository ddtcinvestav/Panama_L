`timescale 1ns/1ps

module adder_tree (input [7:0] in0, input [7:0] in1, input [7:0] in2, input [7:0] in3, output [9:0] sum, output all_zero);

assign sum = in0 + in1 + in2 + in3;
assign all_zero = (sum == 0);

endmodule