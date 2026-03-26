module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry,
    output logic       overflow,
    output logic       negative
);

    logic [8:0] full_result;

    always_comb begin
        full_result = 9'h000;
        carry       = 1'b0;
        overflow    = 1'b0;

        case (op)
            4'h0: begin // ADD
                full_result = {1'b0, a} + {1'b0, b};
                carry       = full_result[8];
                overflow    = (~a[7] & ~b[7] &  full_result[7]) |
                              ( a[7] &  b[7] & ~full_result[7]);
            end
            4'h1: begin // SUB
                full_result = {1'b0, a} - {1'b0, b};
                carry       = full_result[8];
                overflow    = (~a[7] &  b[7] &  full_result[7]) |
                              ( a[7] & ~b[7] & ~full_result[7]);
            end
            4'h2: full_result = {1'b0, a & b};   // AND
            4'h3: full_result = {1'b0, a | b};   // OR
            4'h4: full_result = {1'b0, a ^ b};   // XOR
            4'h5: full_result = {1'b0, ~a};       // NOT
            4'h6: begin // SHL
                full_result = {1'b0, a << 1};
                carry       = a[7];
            end
            4'h7: begin // SHR
                full_result = {1'b0, a >> 1};
                carry       = a[0];
            end
            4'h8: full_result = (a < b) ? 9'h001 : 9'h000; // SLT
            4'h9: full_result = {1'b0, a[3:0] * b[3:0]};   // MUL
            default: begin // NOP
                full_result = 9'h000;
                carry       = 1'b0;
                overflow    = 1'b0;
            end
        endcase
    end

    assign result   = full_result[7:0];
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule