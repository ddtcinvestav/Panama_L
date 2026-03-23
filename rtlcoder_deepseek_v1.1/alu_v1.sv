`timescale 1ns/1ps

module alu(
  input  logic [7:0] a,
  input  logic [7:0] b,
  input  logic [3:0] op,
  output logic [7:0] result,
  output logic       zero,
  output logic       carry,
  output logic       overflow,
  output logic       negative
);

  always_comb begin
    case (op)
      4'h0: begin // ADD
        result = a + b;
        carry = result[8];
        overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
      end
      4'h1: begin // SUB
        result = a - b;
        carry = result[8];
        overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
      end
      4'h2: begin // AND
        result = a & b;
        carry = 1'b0;
        overflow = 1'b0;
      end
      4'h3: begin // OR
        result = a | b;
        carry = 1'b0;
        overflow = 1'b0;
      end
      4'h4: begin // XOR
        result = a ^ b;
        carry = 1'b0;
        overflow = 1'b0;
      end
      4'h5: begin // NOT
        result = ~a;
        carry = 1'b0;
        overflow = 1'b0;
      end
      4'h6: begin // SHL
        result = a << 1;
        carry = a[7];
        overflow = 1'b0;
      end
      4'h7: begin // SHR
        result = a >> 1;
        carry = a[0];
        overflow = 1'b0;
      end
      4'h8: begin // SLT
        result = (a < b) ? 8'h01 : 8'h00;
        carry = 1'b0;
        overflow = 1'b0;
      end
      4'h9: begin // MUL
        result = {4'b0, a[3:0]} * {4'b0, b[3:0]};
        carry = 1'b0;
        overflow = 1'b0;
      end
      default: begin // NOP
        result = 8'h00;
        carry = 1'b0;
        overflow = 1'b0;
      end
    endcase
    zero = (result == 8'h00);
    negative = result[7];
  end

endmodule