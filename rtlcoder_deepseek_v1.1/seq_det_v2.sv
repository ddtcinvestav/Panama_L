`timescale 1ns/1ps

module seq_det(
    input clk,
    input rst_n,
    input data_in,
    output reg detected
);

    // Declaración de estados
    parameter IDLE = 2'b00;
    parameter S1 = 2'b01;
    parameter S10 = 2'b10;
    parameter S101 = 2'b11;
    parameter S1011 = 2'b100;

    // Declaración de variables
    reg [2:0] state;
    reg [2:0] next_state;

    // Inicialización de estados
    initial begin
        state <= IDLE;
        detected <= 0;
    end

    // Lógica de estados
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            detected <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Lógica de salida
    always_comb begin
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
            S1: begin
                if (data_in == 0) begin
                    next_state = S10;
                end else begin
                    next_state = S1;
                end
            end
            S10: begin
                if (data_in == 1) begin
                    next_state = S101;
                end else begin
                    next_state = S10;
                end
            end
            S101: begin
                if (data_in == 0) begin
                    next_state = S1011;
                end else begin
                    next_state = S10;
                end
            end
            S1011: begin
                if (data_in == 1) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Lógica de salida
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            detected <= 0;
        end else begin
            if (state == S1011) begin
                detected <= 1;
            end else begin
                detected <= 0;
            end
        end
    end

endmodule