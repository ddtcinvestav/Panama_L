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

reg [8:0] sum;
reg [8:0] diff;

always_comb begin
    case (op)
        4'b0000: begin // Addition
            sum = a + b;
            result = sum[7:0];
            zero = (result == 8'b0);
            carry = sum[8];
            overflow = ((~a[7] & ~b[7] & result[7])) | (a[7] & b[7] & ~result[7]);
            negative = result[7];
        end
        4'b0001: begin // Subtraction
            diff = a - b;
            result = diff[7:0];
            zero = (result == 8'b0);
            carry = ~diff[8];
            overflow = ((~a[7] & b[7] & result[7])) | (a[7] & ~b[7] & ~result[7]);
            negative = result[7];
        end
        4'b0010: begin // AND
            result = a & b;
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0011: begin // OR
            result = a | b;
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0100: begin // XOR
            result = a ^ b;
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0101: begin // NOT
            result = ~a;
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0110: begin // Left Shift
            result = {a[6:0], 1'b0};
            zero = (result == 8'b0);
            carry = a[7];
            overflow = 0;
            negative = result[7];
        end
        4'b0111: begin // Right Shift
            result = {1'b0, a[7:1]};
            zero = (result == 8'b0);
            carry = a[0];
            overflow = 0;
            negative = result[7];
        end
        4'b1000: begin // Compare
            result = (a < b) ? 8'b01 : 8'b00;
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b1001: begin // Multiply
            result = a[3:0] * b[3:0];
            zero = (result == 8'b0);
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        default: begin // NOP
            result = 8'b00000000;
            zero = 1;
            carry = 0;
            overflow = 0;
            negative = 0;
        end
    endcase
end

endmodule