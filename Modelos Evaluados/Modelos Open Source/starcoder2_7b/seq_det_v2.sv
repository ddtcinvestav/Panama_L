`timescale 1ns/1ps

module seq_det(clk, rst_n, data_in, detected);

input clk, rst_n;
input data_in;
output detected;

reg [3:0] state;

always_ff @(posedge clk) begin
if (rst_n) begin
state <= 0;
end
else begin
case (state)
4'b0000: begin
if (data_in) begin
state <= 1;
end
else begin
state <= 0;
end
end
4'b0001: begin
if (data_in) begin
state <= 2;
end
else begin
state <= 1;
end
end
4'b0010: begin
if (data_in) begin
state <= 3;
end
else begin
state <= 2;
end
end
4'b0011: begin
if (data_in) begin
state <= 4;
end
else begin
state <= 3;
end
end
4'b0100: begin
if (data_in) begin
state <= 1;
end
else begin
state <= 4;
end
end
4'b0101: begin
if (data_in) begin
state <= 2;
end
else begin
state <= 1;
end
end
4'b0110: begin
if (data_in) begin
state <= 3;
end
else begin
state <= 2;
end
end
4'b0111: begin
if (data_in) begin
state <= 4;
end
else begin
state <= 3;
end
end
4'b1000: begin
if (data_in) begin
state <= 1;
end
else begin
state <= 4;
end
end
4'b1001: begin
if (data_in) begin
state <= 2;
end
else begin
state <= 1;
end
end
4'b1010: begin
if (data_in) begin
state <= 3;
end
else begin
state <= 2;
end
end
4'b1011: begin
if (data_in) begin
state <= 4;
end
else begin
state <= 3;
end
end
4'b1100: begin
if (data_in) begin
state <= 1;
end
else begin
state <= 4;
end
end
4'b1101: begin
if (data_in) begin
state <= 2;
end
else begin
state <= 1;
end
end
4'b1110: begin
if (data_in) begin
state <= 3;
end
else begin
state <= 2;
end
end
4'b1111: begin
if (data_in) begin
state <= 4;
end
else begin
state <= 3;
end
end
endcase
end
end

always_comb begin
detected = (state == 4);
end

endmodule