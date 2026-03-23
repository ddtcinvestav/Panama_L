`timescale 1ns/1ps

module alu (
    input logic [7:0] a, b,
    input logic [3:0] op,
    output logic [7:0] result,
    output logic zero, carry, overflow, negative
) always_combinational
    // Arithmetic block (op 0,1)
    always 
    begin
        if (op == 0) // sum
            result = a + b;
        else if (op == 1) // subtract
            result = a - b;
        end

        // Check for overflow
        carry = a ^ b; // XOR to find carry
        if (carry != 0) overflow = true;
        else overflow = false;
    end

    // Logic block (op 2-5)
    always 
    begin
        if (op == 2) // AND
            result = a & b;
        else if (op == 3) // OR
            result = a | b;
        else if (op == 4) // XOR
            result = a ^ b;
        else if (op == 5) // NOT
            result = ~a;
        end

        // No carry or overflow
    end

    // Shifter block (op 6,7)
    always 
    begin
        if (op == 6) // left shift
            result = a << 1;
        else if (op == 7) // right shift
            result = a >> 1;
        end
    end

    // Comparator block (op 8)
    always 
    begin
        if (a < b) result = 0x01;
        else result = 0x00;
    end

    // Multiplier block (op 9)
    always 
    begin
        if (a == 0) result = 0x00;
        else if (b == 0) result = 0x00;
        else result = a * b;
    end

    // Output selection (op 6,7)
    always 
    begin
        if (op == 0) result = 0;
        else if (op == 1) result = 1;
        else if (op == 2) result = 2;
        else if (op == 3) result = 3;
        else if (op == 4) result = 4;
        else if (op == 5) result = 5;
        else if (op == 6) result = 6;
        else if (op == 7) result = 7;
        else if (op == 8) result = 8;
        else if (op == 9) result = 9;
    end

    // Flags
    always 
    begin
        zero = (op == 0);
        negative = (a[7] == 1 && op == 2);
        carry = (a[7] == 1 && op == 6);
        overflow = (a[7] == 1 && op == 0);
    end