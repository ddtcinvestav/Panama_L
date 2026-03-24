module seq_det(input clk, rst_n, data_in, output reg detected);
parameter IDLE=3'b000;
parameter S1 = 3'b001;
parameter S10 = 3'b010;
parameter S101 = 3'b011;
parameter S1011 = 3'b100;

reg [2:0] state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state <= IDLE;
detected <= 1'b0;
end else begin
state <= next_state;
detected <= (state == S1011);
end
end

always @* begin
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
      next_state = S1;
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
      next_state = S1;
    end
  end
  
  S1011: begin
    next_state = S1;
  end
endcase
end

endmodule