`timescale 1ns/1ps

module seq_det(input clk,
               input rst_n,
               input [7:0] data_in,
               output reg detected,
               state IDLE,
               state S1,
               state S10,
               state S101,
               state S1011);

   // Clk and rst_n are input ports
   clock clk_clk(clk);
   reset rst_n_rst_n(rst_n);

   // Pins for detecting "1011"
   reg [7:0] rd_data;
   reg [7:0] rd_data_prev;

   // Detect "1011" in data_in
   always_comb begin
      rd_data = data_in;
      rd_data_prev = rd_data;
      if (rd_data == 1011) begin
         // IDLE
         detected = 1;
      end
      else begin
         // S1
         if (rd_data_prev == 101) begin
            rd_data_prev = rd_data;
            detected = 1;
         end
         else begin
            // S10
            if (rd_data_prev == 100) begin
               rd_data_prev = rd_data;
               detected = 1;
            end
            else begin
               // S101
               if (rd_data_prev == 101) begin
                  rd_data_prev = rd_data;
                  detected = 1;
               end
               else begin
                  // S1011
                  if (rd_data_prev == 1011) begin
                     rd_data_prev = rd_data;
                     detected = 1;
                  end
               end
            end
         end
      end
   end

endmodule