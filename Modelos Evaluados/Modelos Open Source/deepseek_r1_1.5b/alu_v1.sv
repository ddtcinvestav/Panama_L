`timescale 1ns/1ps

module alu (
    a, b, op, result, zero, carry, overflow, negative
 )
    always_comb (
        result = 0,
        zero = (result == 8'h00),
        carry = (op == 4'h1),
        overflow = (op == 4'h5) & (result == 8'h00),
        negative = (op == 4'h6) & (a[7] == 8'h10)
    )
    always_comb (
        case op
        when 0
            result = a | b
            zero = (a == b)
            carry = (a[7] == b[7])
            overflow = (a[7] == b[7] == 8'h10)
            negative = (a[7] == b[7] == 8'h10)
        when 1
            result = a - b
            zero = (a == b)
            carry = (a[7] == 0) & (b[7] == 0)
            overflow = (a[7] == 0) & (b[7] == 0)
            negative = (a[7] == b[7] == 8'h10)
        when 2
            result = a & b
            zero = (a == 0) & (b == 0)
            carry = 0
            overflow = (a == 0) | (b == 0)
            negative = (a == b == 8'h10)
        when 3
            result = a | b
            zero = (a == b)
            carry = (a[7] == b[7])
            overflow = (a[7] == b[7] == 8'h10)
            negative = (a[7] == b[7] == 8'h10)
        when 4
            result = a + b
            zero = (a == 0) | (b == 0)
            carry = (a[7] == 0) & (b[7] == 0)
            overflow = (a[7] == 0) | (b[7] == 0)
            negative = (a[7] == b[7] == 8'h10)
        when 5
            result = a - b
            zero = (a == b)
            carry = (a[7] == 0) & (b[7] == 0)
            overflow = (a[7] == 0) | (b[7] == 0)
            negative = (a[7] == b[7] == 8'h10)
        when 6
            result = a << 1
            zero = (a == 0)
            carry = (a[7] == 1)
            overflow = (a[7] == 1)
            negative = (a[7] == 1)
        when 7
            result = a >> 1
            zero = (a == 0)
            carry = (a[0] == 0)
            overflow = (a[0] == 0)
            negative = (a[0] == 0)
        when 8
            result = 0
            zero = true
            carry = 0
            overflow = false
            negative = false
        when 9
            result = a[3:0] * b[3:0]
            zero = (a == 0) | (b == 0)
            carry = 0
            overflow = (a == 0) | (b == 0)
            negative = (a == b == 8'h10)
    );