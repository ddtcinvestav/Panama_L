`timescale 1ns/1ps

Algoritmo:

```
module alu(
    input [7:0] a,
    input [7:0] b,
    output [7:0] result,
    output [3:0] zero,
    output [7:0] carry,
    output [7:0] overflow,
    output [7:0] negative
);

   Reg#(Bit#(8)) zero_reg <- mkReg(0);
   Reg#(Bit#(8)) carry_reg <- mkReg(0);
   Reg#(Bit#(8)) overflow_reg <- mkReg(0);
   Reg#(Bit#(7)) result_reg <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_2 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_2 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_2 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_2 <- mkReg(0);

   Reg#(Bit#(8)) a_reg <- mkReg(0);
   Reg#(Bit#(8)) b_reg <- mkReg(0);

   Reg#(Bit#(8)) result_reg_1 <- mkReg(0);
   Reg#(Bit#(8)) zero_reg_1 <- mkReg(0);
   Reg#(Bit#(8)) carry_reg_1 <- mkReg(0);
   Reg#(Bit#(8)) overflow_reg_1 <- mkReg(0);
   Reg#(Bit#(8)) result_reg_2 <- mkReg(0);
   Reg#(Bit#(8)) zero_reg_2 <- mkReg(0);
   Reg#(Bit#(8)) carry_reg_2 <- mkReg(0);
   Reg#(Bit#(8)) overflow_reg_2 <- mkReg(0);

   Reg#(Bit#(7)) result_reg_3 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_3 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_3 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_3 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_4 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_4 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_4 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_4 <- mkReg(0);

   Reg#(Bit#(7)) result_reg_5 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_5 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_5 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_5 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_6 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_6 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_6 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_6 <- mkReg(0);

   Reg#(Bit#(7)) result_reg_7 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_7 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_7 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_7 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_8 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_8 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_8 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_8 <- mkReg(0);

   Reg#(Bit#(7)) result_reg_9 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_9 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_9 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_9 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_10 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_10 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_10 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_10 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_11 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_11 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_11 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_11 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_12 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_12 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_12 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_12 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_13 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_13 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_13 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_13 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_14 <- mkReg(0);
   Reg#(Bit#(7)) zero_reg_14 <- mkReg(0);
   Reg#(Bit#(7)) carry_reg_14 <- mkReg(0);
   Reg#(Bit#(7)) overflow_reg_14 <- mkReg(0);
   Reg#(Bit#(7)) result_reg_15 <- mkReg(0);
   Reg#(Bit#(8)) result_reg_16 <- mkReg(0);
   Reg#(Bit#(8) reg_17) result_reg_18 <- mklaut;
   Reg#(8) result_reg_19;
   Reg#(Bit#a_b)
   module_100;
   Signal#10_115;
   Signal10, Signal#11
     10-b1.1,10,14,10.