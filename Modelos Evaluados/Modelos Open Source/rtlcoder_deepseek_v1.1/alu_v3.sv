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
      4'b0000: begin // ADD
        {carry, result} = a + b;
        zero = (result == 8'h00);
        overflow = ((~a[7]&~b[7]&result[7])|(a[7]&b[7]&~result[7]));
        negative = result[7];
      end
      4'b0001: begin // SUB
        {carry, result} = a - b;
        zero = (result == 8'h00);
        overflow = ((~a[7]&b[7]&result[7])|(a[7]&~b[7]&~result[7]));
        negative = result[7];
      end
      4'b0010: begin // AND
        result = a & b;
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      4'b0011: begin // OR
        result = a | b;
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      4'b0100: begin // XOR
        result = a ^ b;
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      4'b0101: begin // NOT
        result = ~a;
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      4'b0110: begin // SHL
        result = {a[6:0], 1'b0};
        zero = (result == 8'h00);
        carry = a[7];
        overflow = 1'b0;
        negative = result[7];
      end
      4'b0111: begin // SHR
        result = {1'b0, a[7:1]};
        zero = (result == 8'h00);
        carry = a[0];
        overflow = 1'b0;
        negative = result[7];
      end
      4'b1000: begin // SLT
        result = (a < b) ? 8'h01 : 8'h00;
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      4'b1001: begin // MUL
        result = {a[3:0], b[3:0]};
        zero = (result == 8'h00);
        carry = 1'b0;
        overflow = 1'b0;
        negative = result[7];
      end
      default: begin // F
        result = 8'h00;
        zero = 1'b1;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
      end
    endcase
  end

endmodule