`timescale 1ns/1ps

module adder_tree (
    inputs in0-in3[7:0], 
    outputs sum[9:0], 
    outputs all_zero[4:0]
) 
    constant sum01[8:0] 
    constant sum23[8:0]
{
    // Step 1: Declare the sum variables
    logic[8:0] sum01, sum23;

    // Step 2: Assign the sums
    sum01 = {1'b0, in0} + {1'b0, in1};
    sum23 = {1'b0, in2} + {1'b0, in3};

    // Step 3: Combine the sums into the final sum
    sum = {1'b0, sum01} + {1'b0, sum23};

    // Step 4: Set all_zero to 0 when sum is 0x000
    all_zero = (sum == 10'h000);
}