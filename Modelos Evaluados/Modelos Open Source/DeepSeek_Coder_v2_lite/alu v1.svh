module alu (
    input        [7:0] a,
    input        [7:0] b,
    input        [3:0] op,
    output logic [7:0] result,
    output       zero,
    output       carry,
    output       overflow,
    output       negative
);
    always_comb begin
        case (op)
            4'h0: result = a + b; // ADD
            4'h1: result = a - b; // SUB
            4'h2: result = a & b; // AND
            4'h3: result = a | b; // OR
            4'h4: result = a ^ b; // XOR
            4'h5: result = ~a;    // NOT
            4'h6: result = (a << 1); // SHL
            4'h7: result = (a >> 1); // SHR
            4'h8: result = a < b ? 8'h01 : 8'h00; // SLT
            4'h9: result = a * b; // MUL
            default: result = 8'h00; // NOP
        endcase
        
        zero = (result == 8'h00);
        carry = op[2];
        overflow = (op == 4'h0 && ((a[7] & b[7] && !b[7]) || (!a[7] & b[7] && a[7]))) ? 1 : 0;
        negative = result[7];
    end
endmodule