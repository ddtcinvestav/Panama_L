`timescale 1ns/1ps

module seq_det(input logic clk, rst_n, data_in, output logic detected);
ESTADOS: IDLE(000)→det=0, S1(001)→0, S10(010)→0, S101(011)→0, S1011(100)→1.
TRANSICIONES:
  IDLE:  d=0→IDLE,  d=1→S1
  S1:    d=0→S10,   d=1→S1
  S10:   d=0→IDLE,  d=1→S101
  S101:  d=0→S10,   d=1→S1011
  S1011: d=0→S10,   d=1→S1