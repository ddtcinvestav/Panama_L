`timescale 1ns/1ps

module alu(
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
    case(op)
        4'b0000: begin // suma
            result = a + b;
            carry = (result[8] == 1);
            overflow = (a[7] == b[7] && a[7] != result[7]);
            negative = result[7];
        end
        4'b0001: begin // resta
            result = a - b;
            carry = (result[8] == 1);
            overflow = (a[7] != b[7] && a[7] != result[7]);
            negative = result[7];
        end
        4'b0010: begin // AND bit a bit
            result = a & b;
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0011: begin // OR bit a bit
            result = a | b;
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0100: begin // XOR bit a bit
            result = a ^ b;
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0101: begin // NOT de a
            result = ~a;
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b0110: begin // shift left de a
            result = {a[6:0], carry};
            carry = a[7];
            overflow = 0;
            negative = result[7];
        end
        4'b0111: begin // shift right de a
            result = {carry, a[7:1]};
            carry = a[0];
            overflow = 0;
            negative = result[7];
        end
        4'b1000: begin // a < b
            result = (a < b) ? 8'b00000001 : 8'b00000000;
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        4'b1001: begin // multiplicación de nibbles
            result = {4'b0000, a[3:0]*b[3:0]};
            carry = 0;
            overflow = 0;
            negative = result[7];
        end
        default: begin // result=0, banderas=0
            result = 8'b00000000;
            carry = 0;
            overflow = 0;
            negative = 0;
        end
    endcase
    zero = (result == 8'b00000000);
end

endmodule