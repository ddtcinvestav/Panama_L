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
    case (op)
        4'b0000: begin // ADD
            {carry, result} = a + b;
            overflow = (a[7] == b[7]) && (a[7] != result[7]);
        end
        4'b0001: begin // SUB
            {carry, result} = a - b;
            overflow = (a[7] != b[7]) && (a[7] != result[7]);
        end
        4'b0010: begin // AND
            result = a & b;
            carry = 0;
            overflow = 0;
        end
        4'b0011: begin // OR
            result = a | b;
            carry = 0;
            overflow = 0;
        end
        4'b0100: begin // XOR
            result = a ^ b;
            carry = 0;
            overflow = 0;
        end
        4'b0101: begin // NOT
            result = ~a;
            carry = 0;
            overflow = 0;
        end
        4'b0110: begin // SHL
            result = {1'b0, a} << 1;
            carry = a[7];
            overflow = 0;
        end
        4'b0111: begin // SHR
            result = {a[0], a} >> 1;
            carry = a[0];
            overflow = 0;
        end
        4'b1000: begin // SLT
            result = (a < b) ? 8'd1 : 8'd0;
            carry = 0;
            overflow = 0;
        end
        4'b1001: begin // MUL
            result = a[3:0] * b[3:0];
            carry = 0;
            overflow = 0;
        end
        default: begin // Default
            result = 8'd0;
            carry = 0;
            overflow = 0;
        end
    endcase

    zero = (result == 8'd0);
    negative = result[7];
end

endmodule