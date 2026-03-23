module adder_tree (
    input logic [7:0] in0,  // Entrada 0
    input logic [7:0] in1,  // Entrada 1
    input logic [7:0] in2,  // Entrada 2
    input logic [7:0] in3,  // Entrada 3
    output logic [9:0] sum, // Suma de entrada (9 bits)
    output logic all_zero   // Bandera que indica si la suma es cero
);

    // Nivel 1: Sumadores parciales
    logic [7:0] sum01 = in0 + in1;  // Suma parcial entre in0 e in1 con extensión de signo
    logic [7:0] sum23 = in2 + in3; // Suma parcial entre in2 e in3 con extensión de signo

    // Nivel 2: Extensión de signo y suma final
    logic [8:0] sum_ext0 = {1'b0, sum01}; // Extensión de signo para el sumador C
    logic [8:0] sum_ext1 = {1'b0, sum23}; // Extensión de signo para el sumador C
    logic [9:0] sum_c = sum_ext0 + sum_ext1; // Suma final

    // Bandera all_zero
    assign all_zero = (sum_c == 10'h000); // Verificar si la suma es cero

    // Asignar el resultado de la suma a 'sum'
    assign sum = sum_c;

endmodule