`timescale 1ns/1ps

module alu(
  input  logic [7:0] a,
  input  logic [7:0] b,
  input  logic [3:0] op,
  output logic [7:0] result,
  output logic zero,
  output logic carry,
  output logic overflow,
  output logic negative
);

endmodule