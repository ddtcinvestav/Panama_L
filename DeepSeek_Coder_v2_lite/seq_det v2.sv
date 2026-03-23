module seq_det (clk, rst_n, data_in, detected);
    input clk;
    input rst_n;
    input data_in;
    output reg detected;

    parameter IDLE = 3'b000;
    parameter S1 = 3'b001;
    parameter S10 = 3'b010;
    parameter S101 = 3'b011;
    parameter S1011 = 3'b100;

    reg [2:0] current_state, next_state;
    reg detected;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                detected = 1'b0;
            end
            S1: begin
                if (data_in == 1'b1) begin
                    next_state = S10;
                end else begin
                    next_state = IDLE;
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
                if (data_in == 1'b0) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule