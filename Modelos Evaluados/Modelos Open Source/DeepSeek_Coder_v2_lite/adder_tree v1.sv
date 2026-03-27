module adder_tree (
    input  [7:0] in0,
    input  [7:0] in1,
    input  [7:0] in2,
    input  [7:0] in3,
    output [9:0] sum,
    output       all_zero
);

logic [8:0] sum01;
logic [8:0] sum23;
logic [9:0] sum_final;

assign sum01 = (in0 + in1) % 256; // Suma de dos entradas con overflow
assign sum23 = (in2 + in3) % 256; // Suma de otras dos entradas con overflow
assign sum_final = sum01 + sum23; // Suma los resultados intermedios
assign all_zero = (sum_final == 10'h0); // Verifica si el resultado es cero
assign sum = sum_final % 65536; // Overflow a 16 bits

endmodule