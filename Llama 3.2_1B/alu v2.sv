module alu (
    input logic [7:0] a[7], b[7], op[3:0],
    output logic [7:0] result[7:], zero, carry, overflow, negative
);

    always_comb
        case (op)
            4'h0: 
                if (!zero) then
                    result <= a + b;
                else
                    result <= (~a & ~b);
                endcase

            4'h1: 
                if (!zero || carry) then
                    result <= a - b;
                endcase

            4'h2: 
                if (carry && !zero) then
                    result <= a | (~b);
                else
                    result <= a & b;
                endcase

            4'h3: 
                if (!carry || zero) then
                    result <= ~a | (~b);
                endcase

            4'h4: 
                if (zero && carry) then
                    result <= a[3:0] * b[3:0];
                else
                    result <= ((~a[7]) & ~b[7]) | (~a[7]) & (~b[7]);
                endcase

            1'b00: 
                if (carry && !zero) then
                    carry <= a[7] & b[7];
                else
                    carry <= ~a[3] | ~b[3];
                endcase

            1'b01: 
                zero <= (~a[7]);
                overflow <= ~a[7] & ~b[7];

            1'b10: 
                if (a < b) then
                    result <= 8'h00;
                else
                    carry <= ~a[3];
                    result <= a[0];
                endcase

            1'b11: 
                if (carry || zero && a < b) then
                    negative <= (~a);
                else
                    negative <= a | (~b);
                endcase

        endcase
    endall

endmodule