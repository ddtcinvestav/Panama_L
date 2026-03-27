`timescale 1ns/1ps

// Ejercicio 2.1

module seq_det(input logic clk,rst_n,data_in, output logic detected);

localparam IDLE=0,S1=1,S10=2,S101=3,S1011=4;
localparam IDLE_S1=1'b0,S1_S1=1'b0,S1_S10=1'b1,S10_S101=1'b0,S101_S1=1'b1,S101_S10=1'b0,S1011_S101=1'b1,S1011_S1=1'b0;

reg [2:0] state;
reg detected;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state<=0;
  end else begin
    case (state)
      IDLE: if (data_in) begin
        state<=S1;
      end
      S1: if (data_in) begin
        state<=S10;
      end else begin
        state<=IDLE;
      end
      S10: if (data_in) begin
        state<=S101;
      end else begin
        state<=S1;
      end
      S101: if (data_in) begin
        state<=S1011;
      end else begin
        state<=S10;
      end
      S1011: if (data_in) begin
        state<=S101;
      end else begin
        state<=S1;
      end
    endcase
  end
end

assign detected=state==3'b100;

endmodule