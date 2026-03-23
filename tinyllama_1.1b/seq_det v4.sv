`timescale 1ns/1ps

module seq_det(input clk, reset_n, input data_in, output reg [3:0] detected);
  Reg [3:0] state;
  Reg [2:0] state_next;
  Reg [1:0] state_idle;
  Reg [0:0] state_1;
  Reg [0:0] state_10;
  Reg [0:0] state_101;
  Reg [0:0] state_1011;

  always @(posedge clk) begin
    state <= state_idle;
    state_next <= state_idle;
    state_idle <= state_1;
    state_1 <= state_10;
    state_10 <= state_101;
    state_101 <= state_1011;
    state_1011 <= state_1;
  end

  rule detect_sequence (state == 3'b100);
    $display ("Detected sequence: %d", state_idle);
    detected <= state_idle;
  endrule
endmodule