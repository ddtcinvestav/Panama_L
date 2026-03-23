`timescale 1ns/1ps

module adder_tree(inputs in0, inputs in1, inputs in2, inputs in3, outputs sum, outputs all_zero);

      // Declare logic
      logic [8:0] sum01, sum23;

      // Assign values
      assign sum01 = {1'b0, in0};
      assign sum23 = {1'b0, in1};

      // Assign values
      assign sum = {1'b0, sum01} + {1'b0, sum23};

      // Assign values
      assign all_zero = (sum == 10'h000);
   endmodule