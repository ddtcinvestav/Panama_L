`timescale 1ns/1ps

module alu (
    a[7:0], b[7:0], op[3:0], result[7:0], zero, carry, overflow, negative, 
    zero_flag, carry_flag, mul, shift, shift_right
) 
always_comb (
    result = a + b;
    carry = a | b;
    result = result - b;
    carry = a & (~b);
    carry = carry << 1;
    carry = carry & result;
    overflow = carry & result;
    negative = result[7];
    zero = result == 0;
    zero_flag = zero;
    carry_flag = carry;
    mul = a[3:0] & b[3:0];
    shift = a << 1;
    shift_right = a >> 1;
    shift = shift | carry;
    shift_right = shift_right | carry;
    shift = shift | carry;
    shift_right = shift_right | carry;
)
endmodule