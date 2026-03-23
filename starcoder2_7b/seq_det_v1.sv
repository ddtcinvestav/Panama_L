`timescale 1ns/1ps

module seq_det(
input clk,
input rst_n,
input data_in,
output detected
);

reg [2:0] state;

always_ff @(posedge clk) begin
if (rst_n==1'b0)
state <= 0;
else
state <= state;
end

always_comb begin
case (state)
0: if (data_in==1'b1)
state <= 1;
else
state <= 0;
1: if (data_in==1'b1)
state <= 2;
else
state <= 1;
2: if (data_in==1'b1)
state <= 3;
else
state <= 0;
3: if (data_in==1'b1)
state <= 4;
else
state <= 2;
4: if (data_in==1'b1)
state <= 4;
else
state <= 3;
default:
state <= 0;
endcase
end

assign detected = (state==4'b1011);

endmodule