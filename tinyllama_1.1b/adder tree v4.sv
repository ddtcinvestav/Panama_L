`timescale 1ns/1ps

module mkAdderTree(input [7:0] in0,in1,in2,in3, output [9:0] sum);
    Reg#(Bit#(8)) rg_sum <- mkReg(0);
    Reg#(Bit#(9)) rg_zero_extend <- mkReg(0);

    rule zero_extend_sum;
        rg_zero_extend <= rg_sum[8:0];
    endrule

    rule add_sum;
        sum[9:0] <= rg_sum[8:0] + rg_zero_extend[8:0];
        rg_sum <= rg_zero_extend[8:0];
    endrule

    rule all_zero;
        all_zero <= rg_zero_extend[8:0];
    endrule
endmodule