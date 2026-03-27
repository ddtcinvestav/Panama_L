module alu(
    input logic [7:0] a[7], b[7], op[3:0],
    output logic [7:0] result[7:], zero, carry, overflow, negative
);

    always_comb
        case (op)
            4'h1:
                if (!zero || carry) then
                    if (zero) then
                        carry <= a[3:0];
                    else
                        carry <= ~a[2:0] | b[2:0];
                endcase

            4'h2:
                if (carry && !zero) then
                    result <= a[7] & b[7];
                endcase

            4'h3:
                if (!carry || zero) then
                    result <= ~a | b;
                endcase

            4'h4:
                if (zero && carry) then
                    carry <= a[2:0] & b[2:0];
                else
                    carry <= (~a[7]) & (~b[7]);
                endcase

            4'h5:
                if (carry || zero) then
                    if (!zero) then
                        result <= ~a;
                    endcase

            4'h6:
                if (zero && carry) then
                    result <= a[3:0] & b[2:0];
                else
                    result <= a[7] | b[7];
                endcase

            4'h7:
                if (!carry || zero) then
                    result <= ~a[7] | b[7];
                endcase

            4'h8:
                carry <= (a[7]&~b[7])|(a[7]&~(a[0]^b[0]));
                overflow <= (~a[7])&~(b[7]);

        endcase
    endall

endmodule