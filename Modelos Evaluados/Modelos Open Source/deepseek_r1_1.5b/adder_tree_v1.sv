`timescale 1ns/1ps

adder_tree: module (
    in0: logic[7:0],
    in1: logic[7:0],
    in2: logic[7:0],
    in3: logic[7:0],
    sum: logic[9:0],
    all_zero: logic[2:0]
) 
    uses adder

    logic[8:0] sum01 = adder(in0, in1)
    logic[8:0] sum23 = adder(in2, in3)
    sum = adder(sum01, sum23)
    all_zero = sum == 10'h0000000
endmodule