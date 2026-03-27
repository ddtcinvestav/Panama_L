`timescale 1ns/1ps

module seq_det(
    input clk,
    input rst_n,
    input data_in,
    output detected
);

    typedef enum logic[2:0] {
        IDLE = 3'b000,
        S1 = 3'b001,
        S10 = 3'b010,
        S101 = 3'b011,
        S1011 = 3'b100
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
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
            end
            S1: begin
                if (data_in) begin
                    next_state = S1;
                end else begin
                    next_state = S10;
                end
            end
            S10: begin
                if (data_in) begin
                    next_state = IDLE;
                end else begin
                    next_state = S10;
                end
            end
            S101: begin
                if (data_in) begin
                    next_state = S10;
                end else begin
                    next_state = S1011;
                end
            end
            S1011: begin
                if (data_in) begin
                    next_state = S10;
                end else begin
                    next_state = S1;
                end
            end
        endcase
    end

    assign detected = (state == S1011);

endmodule