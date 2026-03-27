`timescale 1ns/1ps

module adder_tree(
    input  [7:0] in0,
    input  [7:0] in1,
    input  [7:0] in2,
    input  [7:0] in3,
    output [9:0] sum,
    output  [1] all_zero
);

   logic [8:0] logic_array[8];
   logic_array[0] = in0[7:0];
   logic_array[1] = in1[7:0];
   logic_array[2] = in2[7:0];
   logic_array[3] = in3[7:0];

   logic [8:0] sum_array[8];
   sum_array[0] = {1'b0, logic_array[0]};
   sum_array[1] = {1'b0, logic_array[1]};
   sum_array[2] = {1'b0, logic_array[2]};
   sum_array[3] = {1'b0, logic_array[3]};

   logic [8:0] sum_array_copy[8];
   sum_array_copy[0] = sum_array[0];
   sum_array_copy[1] = sum_array[1];
   sum_array_copy[2] = sum_array[2];
   sum_array_copy[3] = sum_array[3];

   logic [8:0] all_zero_array[8];
   all_zero_array[0] = all_zero;
   all_zero_array[1] = all_zero;
   all_zero_array[2] = all_zero;
   all_zero_array[3] = all_zero;

   rule add_arrays;
      sum = sum_array_copy;
      all_zero = all_zero_array;
   endrule

   rule add_arrays_copy;
      sum_array_copy = sum_array;
      all_zero_array = all_zero;
   endrule

   rule add_arrays_copy_all_zero;
      all_zero_array = all_zero_array;
   endrule

   rule output_array;
      sum = sum_array;
      all_zero = all_zero_array;
   endrule

endmodule