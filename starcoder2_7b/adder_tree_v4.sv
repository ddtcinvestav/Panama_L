`timescale 1ns/1ps

module adder_tree(input logic [7:0] in0,in1,in2,in3, output logic [9:0] sum, output logic all_zero);

assign sum = in0 + in1 + in2 + in3;
assign all_zero = (sum == 0);
endmodule