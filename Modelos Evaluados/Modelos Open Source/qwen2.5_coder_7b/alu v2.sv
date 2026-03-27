`timescale 1ns/1ps

module alu (
    input [7:0] a,
    input [7:0] b,
    input [3:0] op,
    output reg [7:0] result,
    output reg zero,
    output reg carry,
    output reg overflow,
    output reg negative
);

    always_comb begin
        zero = 1;
        carry = 0;
        overflow = 0;
        negative = 0;

        case (op)
            4'b0000: begin // Suma
                {carry, result} = a + b;
                zero = (result == 8'd0);
                overflow = carry;
                negative = (result[7]);
            end
            4'b0001: begin // Resta
                {carry, result} = a - b;
                zero = (result == 8'd0);
                negative = (result[7]);
            end
            4'b0010: begin // AND
                result = a & b;
                zero = (result == 8'd0);
            end
            4'b0011: begin // OR
                result = a | b;
                zero = (result == 8'd0);
            end
            4'b0100: begin // XOR
                result = a ^ b;
                zero = (result == 8'd0);
            end
            4'b0101: begin // NOT
                result = ~a;
                zero = (result == 8'd0);
            end
            4'b0110: begin // Shift Left
                result = {a[6:0], 1'b0};
                carry = a[7];
                zero = (result == 8'd0);
            end
            4'b0111: begin // Shift Right
                result = {1'b0, a[7:1]};
                carry = a[0];
                zero = (result == 8'd0);
            end
            4'b1000: begin // Comparación sin signo
                result = (a < b) ? 8'd1 : 8'd0;
                zero = (result == 8'd0);
            end
            4'b1001: begin // Multiplicación de nibbles bajos
                result = (a[3:0] * b[3:0]);
                zero = (result == 8'd0);
            end
            default: begin
                result = 8'd0;
                zero = 1;
            end
        endcase

        if (op == 4'b0000 || op == 4'b0001) begin
            overflow = ((a[7] == b[7]) && (a[7] != result[7]));
        end
    end

endmodule