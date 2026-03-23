module alu (
    input logic a[7:0], b[7:0],
    input logic op[3:0], result[7:0], zero, carry,
    output logic [7:0]
);

    always_comb
        case (op[3:])
            4'h0: 
                if (zero || carry) then
                    result <= a + b;
                else
                    result <= a & ~b;
            4'h1: 
                if (zero || carry || !zero) then
                    if (!zero) then
                        result <= a - b;
                    else
                        result <= ~a | (~b);
                endcase

            4'h2: 
                if (zero || carry || zero) then
                    if (zero) then
                        result <= a & b;
                    else
                        result <= a | ~b;
                endcase
            4'h3: 
                if (zero || carry || !zero) then
                    if (!zero) then
                        result <= a ^ b;
                    else
                        result <= a & (~b);
                endcase

            4'h4: 
                if (zero || carry || zero) then
                    if (zero) then
                        result <= ~a;
                    else
                        result <= a | a;
                endcase

            4'h5: 
                if (zero || carry || !zero) then
                    if (!zero) then
                        result <= ~a;
                    endcase

            4'h6: 
                if (zero || carry || zero) then
                    if (zero) then
                        result <= a << 1;
                    else
                        result <= a >> 1;
                endcase

            4'h7: 
                if (zero || carry || !zero) then
                    if (!zero) then
                        result <= ~a[7];
                    endcase

            4'h8: 
                if (zero || carry || zero) then
                    if (zero) then
                        result <= a[3:0] * b[3:0];
                    else
                        result <= ((~a[3:7]) & ~b[3:7]) | (~a[3:7]) & (~b[3:7]);
                endcase

            4'h9: 
                if (zero || carry || !zero) then
                    if (!zero) then
                        result <= a[3:0] * b[3:0];
                    endcase

            1'b00: 
                zero <= (result == 8'h00);
            1'b01: 
                carry <= ((~a[7]) & ~b[7]) | (a[7] & b[7]);
            1'b10: 
                overflow <= (~a[7]) & ~b[7];
            1'b11: 
                negative <= result[7];

        endcase
    endall

endmodule