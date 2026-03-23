`timescale 1ns/1ps

module seq_det(clk, rst_n, data_in, detected);
input clk, rst_n;
input data_in;
output detected;

typedef enum logic[2:0] {IDLE,S1,S10,S101,S1011} state_t;
state_t state, next_state;

always_ff @(posedge clk or negedge rst_n)
if(!rst_n) state<=IDLE;
else state<=next_state;

always_comb
case(state)
S1: next_state=S10;
S10: next_state=S101;
S101: next_state=S1011;
S1011: next_state=S101;
default: next_state=IDLE;
endcase

assign detected=(state==S1011);
endmodule