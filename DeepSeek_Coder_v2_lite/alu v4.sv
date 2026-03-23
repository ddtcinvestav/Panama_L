module alu (input logic [7:0] a, b, input logic [3:0] op,
            output logic [7:0] result, output logic zero, carry, overflow, negative);

  logic [7:0] r;
  logic zero_flag, carry_flag, overflow_flag, negative_flag;

  always_comb begin
    case (op)
      4'b0000: r = a + b; // ADD
      4'h1: r = a - b;   // SUB
      4'h2: r = a & b;   // AND
      4'h3: r = a | b;   // OR
      4'h4: r = a ^ b;   // XOR
      4'h5: r = ~a;     // NOT
      4'h6: r = (a << 1); // SHL
      4'h7: r = (a >> 1); // SHR
      4'h8: r = (a < b) ? 8'b0000_0001 : 8'b0000_0000; // SLT
      4'h9: begin
        r = a[3:0] * b[3:0]; // Mul nibbles
      end
      default: r = 8'h00;
    endcase
    
    zero = (r == 8'b0);
    carry = overflow_flag;
    overflow = overflow_flag;
    negative = r[7];
  end
endmodule