module alu (input logic [7:0] a, b, input logic [3:0] op,
output logic [7:0] result, output logic zero, carry, overflow, negative);
wire [8:0] sum;
wire [8:0] diff;
wire [7:0] mux_result;

// Unidad aritmética
always_comb begin
if (op == 4'h0) begin
sum = {1'b0, a} + {1'b0, b};
carry = (a[7] ^ b[7]) ^ result[7];
overflow = (a[6] & b[6]) | (~a[6] & ~b[6]);
end else if (op == 4'h1) begin
diff = {1'b0, a} - {1'b0, b};
carry = (a[7] ^ ~b[7]) ^ result[7];
overflow = (~a[6] & b[6]) | (a[6] & ~b[6]);
end else begin
sum = 9'h0;
diff = 9'h0;
carry = 1'b0;
overflow = 1'b0;
end
end

// Unidad lógica
always_comb begin
if (op == 4'h2) begin
mux_result = a & b;
end else if (op == 4'h3) begin
mux_result = a | b;
end else if (op == 4'h4) begin
mux_result = a ^ b;
end else if (op == 4'h5) begin
mux_result = ~a;
end else if (op == 4'h6) begin
mux_result = {a[6:0], 1'b0};
end else if (op == 4'h7) begin
mux_result = {1'b0, a[7:1]};
end else if (op == 4'h8) begin
mux_result = (a < b) ? 9'h1 : 9'h0;
end else if (op == 4'h9) begin
mux_result = a[3:0] * b[3:0];
end else begin
mux_result = 8'h0;
end
end

// MUX salida
always @(*) begin
case (op)
4'h0, 4'h1: result = sum[7:0];
default: result = mux_result[7:0];
endcase
end

// Banderas
assign zero = (result == 8'h00);
assign negative = result[7];
assign carry = (op == 4'h6) ? a[7] : (op == 4'h7) ? a[0] : carry;
assign overflow = (op == 4'h0 || op == 4'h1) ? overflow : 1'b0;

endmodule