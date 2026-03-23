`timescale 1ns/1ps

module adder_tree(input logic [7:0] in0,in1,in2,in3, output logic [9:0] sum, output logic all_zero);
    // Sumador A: in0 + in1 → sum01 [8:0]
    assign sum01 = adder A(in0, in1);
    
    // Sumador B: in2 + in3 → sum23 [8:0]
    assign sum23 = adder B(in2, in3);
    
    // Sumador C: sum01 + sum23 → sum [9:0]
    assign sum = adder C(sum01, sum23);
    
    // Zero-extension to 9 bits
    assign ext_bit = not sum;
    assign sum = sum << 1 | ext_bit;
    
    // Zero-extension to 10 bits
    assign all_zero = sum == 0;
endmodule