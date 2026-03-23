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
        case(state)
            IDLE:
                if (data_in)
                    next_state = S1;
            S1:
                if (!data_in)
                    next_state = IDLE;
                else
                    next_state = S10;
            S10:
                if (data_in)
                    next_state = S101;
                else
                    next_state = IDLE;
            S101:
                if (!data_in)
                    next_state = S10;
                else
                    next_state = S1011;
            S1011:
                next_state = S1;
            default:
                next_state = IDLE;
        endcase
    end

    assign detected = (state == S1011);

endmodule