`timescale 1ns/1ps

Okay, I need to create a SystemVerilog module called alu based on the given tables. Let me start by understanding the requirements.

First, the ALU has 8 bits and uses case statements in always_comb. The inputs are a[7:0], b[7:0], and op[3:0]. The outputs are result[7:0], zero, carry, overflow, and negative.

Looking at the table, each op value corresponds to different operations. For example, when op is 0, it's a+b using 8-bit addition. When op is 1, it's a-b using 8-bit subtraction. For op 2-7, it's bitwise operations like AND, OR, etc.

I need to handle each case in the case statement. Each case will have a block of code that performs the corresponding operation.

I should also consider the zero, carry, overflow, and negative outputs. For each operation, I'll need to compute these based on the inputs.

Let me outline the steps:

1. For each op value (0-9), write a case statement.
2. Inside each case, compute the result, zero, carry, overflow, and negative based on the inputs.
3. Use the given formulas for overflow, especially for ADD and SUB.
4. Ensure that the code is synthesizable, so no unnecessary complexity.

I'll start with op=0, which is a+b. I'll use the adder always_comb and extract the result, zero, carry, and overflow.

Next, op=1 is a-b. I'll use the subtractor always_comb and compute the result, zero, carry, and overflow using the given formulas.

For op=2 to 7, these are bitwise operations. I'll use the corresponding always_comb blocks and compute the outputs directly.

For op=8, it's a comparison (a < b). I'll use the compare always_comb and compute the zero, carry, overflow, and negative based on the comparison result.

Op=9 is a multiplication of a[3:0] and b[3:0]. I'll use the multiplier always_comb and compute the result.

Op=10 is a shift right, but since the inputs are 9 bits, I'll handle that in the always_comb.

Op=11 is a shift right with sign extension. Similarly, handled in always_comb.

Op=12 is a shift right with zero extension.

Op=13 is a shift right with sign extension, but the output is 8 bits, so I'll need to adjust.

Op=14 is a shift right with zero extension.

Op=15 is a shift right with sign extension, but the output is 8 bits.

Op=16 is a shift right with zero extension.

Op=17 is a shift right with sign extension, but the output is 8 bits.

Op=18 is a shift right with zero extension.

Op=19 is a shift right with sign extension, but the output is 8 bits.

Op=20 is a shift right with zero extension.

Op=21 is a shift right with sign extension, but the output is 8 bits.

Op=22 is a shift right with zero extension.

Op=23 is a shift right with sign extension, but the output is 8 bits.

Op=24 is a shift right with zero extension.

Op=25 is a shift right with sign extension, but the output is 8 bits.

Op=26 is a shift right with zero extension.

Op=27 is a shift right with sign extension, but the output is 8 bits.

Op=28 is a shift right with zero extension.

Op=29 is a shift right with sign extension, but the output is 8 bits.

Op=30 is a shift right with zero extension.

Op=31 is a shift right with sign extension, but the output is 8 bits.

Wait, I think I might have miscounted. The op values are from 0 to 9, so I need to handle each op correctly.

I should also make sure that the always_comb blocks are correctly connected to the case statements.

I'll start writing the code for each op.

For op=0, a+b:

result = adder(a, b, 8);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

Similarly for op=1, a-b:

result = subtractor(a, b, 8);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

For op=2 to 7, bitwise operations:

result = bitwise_op(a, b, op);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

I'll need to implement each bitwise operation using the appropriate always_comb blocks.

For op=8, comparison:

result = comparator(a, b, 8);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

For op=9, multiplication:

result = multiplier(a, b, 8);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

For op=10 to 19, shift right operations:

result = shift_right(a, b, 8, op);
zero = zero_bit(result);
carry = carry_bit(result);
overflow = overflow_bit(result);

I'll need to implement each of these cases in the module.

I should also ensure that the always_comb blocks are correctly connected to the case statements.

I think that's the general approach. Now, I'll proceed to write the code accordingly.
</think>

```verilog
module alu (
    a[7:0], b[7:0], op[3:0],
    result[7:0], zero, carry, overflow, negative
) always_comb case(op)
    case(op)
    when(0)
        // a + b
        result = adder(a, b, 8);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(1)
        // a - b
        result = subtractor(a, b, 8);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(2)
        // a & b
        result = bitwise_and(a, b);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(3)
        // a | b
        result = bitwise_or(a, b);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(4)
        // a ^ b
        result = bitwise_xor(a, b);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(5)
        // ~a
        result = not(a);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(6)
        // {a[6:0], 1'b0}
        result = bitwise_and(a, 1'b0);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(7)
        // {1'b0, a[7:1]}
        result = bitwise_and(1'b0, a, 7:0);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(8)
        // (a < b) ? 8'h01 : 8'h00
        result = compare(a, b, 8);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(9)
        // a[3:0] * b[3:0]
        result = multiplier(a, b, 8);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(10)
        // a[3:0] >> b[3:0]
        result = shift_right(a, b, 8, 10);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(11)
        // a[3:0] >> 1'b0 with sign extension
        result = shift_right(a, 1'b0, 8, 11);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(12)
        // a[3:0] >> 1'b0 with zero extension
        result = shift_right(a, 1'b0, 8, 12);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(13)
        // a[3:0] >> 1'b0 with sign extension, 8 bits output
        result = shift_right(a, 1'b0, 8, 13);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(14)
        // a[3:0] >> 1'b0 with zero extension, 8 bits output
        result = shift_right(a, 1'b0, 8, 14);
        zero = zero_bit(result);
        carry = carry_bit(result);
        overflow = overflow_bit(result);
    when(15)
        // a[3:0] >> 1'b0 with sign extension, 8 bits output
        result = shift_right(a, 1'b0,