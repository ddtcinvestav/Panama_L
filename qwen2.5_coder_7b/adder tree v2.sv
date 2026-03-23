`timescale 1ns/1ps

module adder_tree (
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    output reg [9:0] sum,
    output reg all_zero
);

assign {sum[9], sum[8:0]} = in0 + in1;
assign {sum[10], sum[9:1]} = in2 + in3;
assign sum = sum[9:0];
assign all_zero = (sum == 0);

endmodule