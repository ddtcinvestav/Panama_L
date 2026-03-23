module seq_det (
    input clk,
    input rst_n,
    input data_in,
    output detected
);

  // Estados definidos como enum
  typedef enum logic[2:0] {IDLE=3'b000, S1=3'b001, S10=3'b010, S101=3'b011, S1011=3'b100};
  seq_state current_state, next_state;

  // Registro de estados actual y siguientes
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // Lógica combinacional para determinar el estado siguiente
  always_comb begin
    case (current_state)
      IDLE: begin
        if (data_in == 1'b1) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S1: begin
        if (data_in == 1'b0) begin
          next_state = S10;
        end else begin
          next_state = S1;
        end
      end
      S10: begin
        if (data_in == 1'b1) begin
          next_state = S101;
        end else begin
          next_state = IDLE;
        end
      end
      S101: begin
        if (data_in == 1'b1) begin
          next_state = S1011;
        end else begin
          next_state = IDLE;
        end
      end
      S1011: begin
        next_state = IDLE;
      end
    endcase
  end

  // Lógica de salida
  assign detected = (current_state == S1011);
endmodule