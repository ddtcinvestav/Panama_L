`timescale 1ns/1ps

module seq_det(
    input logic clk,
    input logic rst_n,
    input logic data_in,
    output logic detected
);

    typedef enum {IDLE, S1, S10, S101, S1011} state_t;
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
            IDLE: begin
                if (data_in)
                    next_state = S1;
            end
            S1: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S10;
            end
            S10: begin
                if (data_in)
                    next_state = S101;
                else
                    next_state = IDLE;
            end
            S101: begin
                if (data_in)
                    next_state = S1011;
                else
                    next_state = S10;
            end
            S1011: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S10;
            end
        endcase
    end

    assign detected = (state == S1011);

endmodule