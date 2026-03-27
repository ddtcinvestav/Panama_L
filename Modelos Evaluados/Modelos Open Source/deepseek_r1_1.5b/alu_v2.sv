`timescale 1ns/1ps

module alu (
    a, b, op,
    result, zero, carry, overflow, negative
) always_comb
    if (op == 0) begin
        sum = a + b;
        carry = (sum >> 7) & 1;
        overflow = (sum == 1) && (carry == 1);
        result = sum;
        zero = (a == 0) && (b == 0);
        carry = carry;
        negative = (a < b);
    elsif (op == 1) begin
        borrow = (a ^ b) == 0;
        sum = a - b;
        carry = borrow;
        overflow = (sum == 1) && (carry == 1);
        result = sum;
        zero = (a == 0) && (b == 0);
        carry = carry;
        negative = (a < b);
    elsif (op == 2) begin
        result = a & b;
        zero = (a == 0) || (b == 0);
        carry = 0;
        overflow = 0;
    elsif (op == 3) begin
        result = a | b;
        zero = (a == 0) || (b == 0);
        carry = 0;
        overflow = 0;
    elsif (op == 4) begin
        result = a ^ b;
        zero = (a == 0) || (b == 0);
        carry = 0;
        overflow = 0;
    elsif (op == 5) begin
        result = ~a;
        zero = (a == 0) || (b == 0);
        carry = 0;
        overflow = 0;
    elsif (op == 6) begin
        result = a << 1;
        carry = (result >> 7) & 1;
        zero = (a == 0) || (b == 0);
        carry = carry;
        overflow = (result == 1) && (carry == 1);
    elsif (op == 7) begin
        result = a >> 1;
        carry = (result >> 7) & 1;
        zero = (a == 0) || (b == 0);
        carry = carry;
        overflow = (result == 1) && (carry == 1);
    elsif (op == 8) begin
        if (a < b) begin
            result = 1;
            zero = 0;
            carry = 0;
            overflow = 1;
        else begin
            result = 0;
            zero = 1;
            carry = 0;
            overflow = 0;
        end
    elsif (op == 9) begin
        a3 = a >> 3;
        b3 = b >> 3;
        product = a3 * b3;
        result = product << 3;
        zero = (a == 0) || (b == 0);
        carry = 0;
        overflow = 0;
    else begin
        result = 0;
        zero = 0;
        carry = 0;
        overflow = 0;
    end
end always_comb