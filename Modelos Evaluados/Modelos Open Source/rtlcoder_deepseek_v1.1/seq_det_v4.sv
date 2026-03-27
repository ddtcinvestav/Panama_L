`timescale 1ns/1ps

module seq_det(input logic clk, rst_n, data_in, output logic detected);

  // Definicion de estados
  enum logic [2:0] {IDLE, S1, S10, S101, S1011} state, next_state;

  // Registro de estados
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Siguiente estado
  always_comb begin
    case (state)
      IDLE: begin
        if (data_in) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S1: begin
        if (data_in) begin
          next_state = S10;
        end else begin
          next_state = IDLE;
        end
      end
      S10: begin
        if (data_in) begin
          next_state = S101;
        end else begin
          next_state = IDLE;
        end
      end
      S101: begin
        if (data_in) begin
          next_state = S1011;
        end else begin
          next_state = S10;
        end
      end
      S1011: begin
        if (data_in) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
    endcase
  end

  // Salida
  assign detected = (state == S1011);

endmodule