`timescale 1ns/1ps

typedef enum logic[2:0] {
    IDLE = 0,
    S1 = 1,
    S10 = 2,
    S101 = 3,
    S1011 = 4,
    S10111 = 5
} seq_det_state;