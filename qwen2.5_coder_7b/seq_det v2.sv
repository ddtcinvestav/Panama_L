`timescale 1ns/1ps

module seq_det (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg detected
);

typedef enum reg [2:0] {IDLE, S1, S10, S101, S1011} state_t;
state_t state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin
    next_state = state;
    detected = 0;
    case (state)
        IDLE:
            if (data_in == 1'b1)
                next_state = S1;
        S1:
            if (data_in == 1'b0)
                next_state = S10;
        S10:
            if (data_in == 1'b1)
                next_state = S101;
        S101:
            if (data_in == 1'b1)
                next_state = S1011;
        S1011:
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = S10;
    endcase
    if (state == S1011 && data_in == 1'b1)
        detected = 1;
end

endmodule