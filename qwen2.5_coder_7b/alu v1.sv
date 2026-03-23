`timescale 1ns/1ps

module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic zero,
    output logic carry,
    output logic overflow,
    output logic negative
);

    logic [8:0] sum;
    logic [7:0] temp_result;

    assign sum = {1'b0, a} + {1'b0, b};
    assign temp_result = sum[7:0];
    assign carry = sum[8];

    always_comb begin
        case (op)
            4'h0: begin // ADD
                result = temp_result;
                zero = (result == 8'h00);
                overflow = ((~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]));
                negative = result[7];
            end
            4'h1: begin // SUB
                result = temp_result - 1;
                zero = (result == 8'h00);
                overflow = ((~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]));
                negative = result[7];
            end
            4'h2: result = a & b; // AND
            4'h3: result = a | b; // OR
            4'h4: result = a ^ b; // XOR
            4'h5: result = ~a;    // NOT
            4'h6: begin          // SHL
                result = {a[6:0], 1'b0};
                carry = a[7];
            end
            4'h7: begin          // SHR
                result = {1'b0, a[6:1]};
                carry = a[0];
            end
            4'h8: begin          // SLT
                result = (a < b) ? 8'h01 : 8'h00;
                zero = (result == 8'h00);
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
            end
            4'h9: begin          // MUL
                result = a[3:0] * b[3:0];
                zero = (result == 8'h00);
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
            end
            default: begin       // NOP
                result = 8'h00;
                zero = 1'b1;
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
            end
        endcase
    end

endmodule