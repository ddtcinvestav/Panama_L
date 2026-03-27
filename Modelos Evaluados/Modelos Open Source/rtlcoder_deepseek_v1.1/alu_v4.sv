`timescale 1ns/1ps

module alu (input logic [7:0] a, b, input logic [3:0] op,
            output logic [7:0] result, output logic zero, carry, overflow, negative);

  logic [8:0] sum;
  logic [3:0] and_out, or_out, xor_out, not_out;
  logic [7:0] mul_out;
  logic [7:0] shl_out, shr_out;
  logic [7:0] comp_out;

  // Unidad aritmética
  always_comb begin
    case (op)
      4'b0000: begin // Sumador
        sum = {1'b0, a} + {1'b0, b};
        result = sum[7:0];
        carry = sum[8];
        overflow = (a[7] == b[7]) && (a[7] != result[7]);
      end
      4'b0001: begin // Restador
        sum = {1'b0, a} - {1'b0, b};
        result = sum[7:0];
        carry = sum[8];
        overflow = (a[7] != b[7]) && (a[7] != result[7]);
      end
      default: begin // Otros
        and_out = a & b;
        or_out = a | b;
        xor_out = a ^ b;
        not_out = ~b;
        mul_out = {a[3:0], b[3:0]} * 4'b0001;
        shl_out = {b[6:0], 1'b0};
        shr_out = {1'b0, b[7:1]};
        comp_out = (a < b) ? 8'h01 : 8'h00;
      end
    endcase
  end

  // Mux salida
  always_comb begin
    case (op)
      4'b0000, 4'b0001: result = sum[7:0];
      4'b0010: result = and_out;
      4'b0011: result = or_out;
      4'b0100: result = xor_out;
      4'b0101: result = not_out;
      4'b0110: result = shl_out;
      4'b0111: result = shr_out;
      4'b1000: result = comp_out;
      4'b1001: result = mul_out;
      default: result = 8'b0;
    endcase
  end

  // Flags
  always_comb begin
    zero = (result == 8'b0);
    negative = result[7];
    carry = (op == 4'b0000) ? sum[8] : shl_out[7];
    overflow = (op == 4'b0000) ? overflow : (op == 4'b0001) ? overflow : 1'b0;
  end

endmodule