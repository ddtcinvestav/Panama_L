`timescale 1ns/1ps

module alu (
    input logic [7:0] a, b,
    input logic [3:0] op,
    output logic [7:0] result,
    output logic zero, carry, overflow, negative
);

    logic [8:0] sum;
    logic [7:0] and_res, or_res, xor_res;
    logic [7:0] shift_left, shift_right;
    logic [7:0] comp_res;
    logic [7:0] mul_res;

    assign sum = {1'b0, a} + {1'b0, ~b} + 1'b1; // Sumador-restador con carry-in
    assign and_res = a & b;
    assign or_res = a | b;
    assign xor_res = a ^ b;
    assign shift_left = {a[6:0], 1'b0};
    assign shift_right = {1'b0, a[6:0]};
    assign comp_res = (a < b) ? 8'h01 : 8'h00;
    assign mul_res = a[3:0] * b[3:0];

    assign result = 
        (op == 4'd0) ? sum[7:0] :
        (op == 4'd1) ? sum[8] :
        (op == 4'd2) ? and_res :
        (op == 4'd3) ? or_res :
        (op == 4'd4) ? xor_res :
        (op == 4'd5) ? ~and_res :
        (op == 4'd6) ? shift_left :
        (op == 4'd7) ? shift_right :
        (op == 4'd8) ? comp_res :
        (op == 4'd9) ? mul_res :
        8'b0;

    assign zero = (result == 8'b0);
    assign negative = result[7];
    assign carry = 
        (op == 4'd0) ? sum[8] :
        (op == 4'd1) ? sum[8] :
        (op == 4'd5) ? ~and_res[7] :
        (op == 4'd6) ? shift_left[7] :
        (op == 4'd7) ? shift_right[7] :
        1'b0;
    assign overflow = 
        (op == 4'd0) ? (sum[8] != (a[7] ^ b[7])) :
        (op == 4'd1) ? (sum[8] != (a[7] ^ ~b[7])) :
        1'b0;

endmodule