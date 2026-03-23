`timescale 1ns/1ps

module seq_det(input logic clk,rst_n,data_in, output logic detected);

always_ff @(posedge clk or negedge rst_n) begin
if (~rst_n) begin
state <= IDLE;
end
else begin
case (state)
IDLE: if (data_in==0) begin
state <= IDLE;
end
else begin
state <= S1;
end
S1: if (data_in==0) begin
state <= S10;
end
else begin
state <= S1;
end
S10: if (data_in==0) begin
state <= IDLE;
end
else begin
state <= S101;
end
S101: if (data_in==0) begin
state <= S10;
end
else begin
state <= S1011;
end
S1011: if (data_in==0) begin
state <= S10;
end
else begin
state <= S1;
end
endcase
end
end

assign detected = (state==S1011);
endmodule