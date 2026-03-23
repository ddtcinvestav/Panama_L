`timescale 1ns/1ps

module adder_tree(
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    output [9:0] sum,
    output all_zero
);

wire [8:0] partial_sum1;
wire [8:0] partial_sum2;

assign partial_sum1 = in0 + in1;
assign partial_sum2 = in2 + in3;

assign sum = partial_sum1 + partial_sum2;
assign all_zero = (sum == 0);

endmodule