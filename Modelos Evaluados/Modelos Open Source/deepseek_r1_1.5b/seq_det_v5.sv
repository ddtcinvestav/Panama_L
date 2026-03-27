`timescale 1ns/1ps

module seq_det (
    clk, rst_n, data_in, detected
) 
    always_ff @(posedge clk or negedge rst_n) :
    if(!rst_n) state<=IDLE; else state<=next_state;
    always_comb case(state):
        transiciones con solapamiento (S101+'0'→S10, S1011+'0'→S1011);
        case(S101)
            transiciones con S1011+'0' → S10;
        case(S1011)
            transiciones con S1011+'0' → S1011;
        default
            always transition to next_state;
    always_output detected = (state == S1011);