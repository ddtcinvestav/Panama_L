`timescale 1ns/1ps

module seq_det(input logic clk, rst_n, data_in, output logic detected);

  typedef enum logic [2:0] {IDLE, S1, S10, S101, S1011} state_t;
  state_t state, next_state;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    case (state)
      IDLE: begin
        if (data_in) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
        detected = 0;
      end
      S1: begin
        if (data_in) begin
          next_state = S1;
        end else begin
          next_state = S10;
        end
        detected = 0;
      end
      S10: begin
        if (data_in) begin
          next_state = S101;
        end else begin
          next_state = IDLE;
        end
        detected = 0;
      end
      S101: begin
        if (data_in) begin
          next_state = S1011;
        end else begin
          next_state = S10;
        end
        detected = 0;
      end
      S1011: begin
        if (data_in) begin
          next_state = S1;
        end else begin
          next_state = S10;
        end
        detected = 1;
      end
    endcase
  end

endmodule