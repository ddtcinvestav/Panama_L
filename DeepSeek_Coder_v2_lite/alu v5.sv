module alu (input logic [7:0] a, b, input logic [2:0] op, 
             output logic [7:0] result, 
             output logic zero, negative, carry, overflow);
  
  logic [7:0] r;
  logic carry, overflow_flag;

  always_comb begin
    case (op)
      3'b000: r = a + b; // ADD operation
      3'h1: r = a - b; // SUB operation
      3'h2: r = a & b; // AND operation
      3'h3: r = a | b; // OR operation
      3'h4: r = a ^ b; // XOR operation
      3'h5: r = ~a;    // NOT operation
      3'h6: r = (a << 1); // SHL operation
      3'h7: r = (a >> 1); // SHR operation
      3'h8: r = (a < b) ? 8'b0000_0001 : 8'b0000_0000; // SLT operation
      3'h9: begin
        // Multiplication operation
        r = a * b; // This is a simplified version and assumes unsigned multiplication
      end
      default: r = 8'h00;
    endcase
    
    zero = (r == 8'b0);
    negative = r[7];
    carry = overflow_flag;
    overflow = overflow_flag;
  end
endmodule