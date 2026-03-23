`timescale 1ns/1ps

adder_tree:

module adder_tree(input in0[7:0], in1[7:0], in2[7:0], in3[7:0], sum[9:0], all_zero, sum01[8:0], sum23[8:0]):

    // First stage: add in0 and in1
    sum01[8:0] = and(and(in0[7:0], in1[7:0]), 
                     add(in0, in1, sum01));

    // Second stage: add sum01 and sum23
    sum[9:0] = add(sum01, sum23, sum);

    // All zero output
    all_zero = and(and(in0[7:0], in1[7:0]), 
                     and(in2[7:0], in3[7:0]));

endmodule