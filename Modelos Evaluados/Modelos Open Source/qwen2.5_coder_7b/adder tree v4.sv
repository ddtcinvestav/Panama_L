`timescale 1ns/1ps

module adder_tree(
    input logic [7:0] in0,
    input logic [7:0] in1,
    input logic [7:0] in2,
    input logic [7:0] in3,
    output logic [9:0] sum,
    output logic all_zero
);

    logic [8:0] sum01;
    logic [8:0] sum23;
    logic [9:0] sum_ext;

    assign sum01 = {1'b0, in0} + {1'b0, in1};
    assign sum23 = {1'b0, in2} + {1'b0, in3};
    assign sum_ext = sum01 + sum23;
    assign sum = sum_ext;
    assign all_zero = (sum == 10'd0);

endmodule