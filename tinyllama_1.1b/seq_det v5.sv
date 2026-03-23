`timescale 1ns/1ps

module seq_det(clk, rst_n, data_in, detected);

   input_clock clk(clk);
   input_reset rst_n(rst_n);
   input_data data_in(data_in);
   output_data detected(detected);

   Reg#(state_t) state <- mkReg(IDLE);
   Reg#(state_t) next_state <- mkReg(IDLE);

   always_ff @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= IDLE;
      end
      else begin
         state <= next_state;
      end
   end

   always_comb begin
      transitions with (state)
         S1011: detected <= state == S1011;
         S10: detected <= state == S10;
         S1: detected <= state == S1;
         S0: detected <= state == IDLE;
      end
   end

endmodule