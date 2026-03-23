module adder_tree (
    input logic [7:0] in0,  // Entrada 0 y 1
    input logic [7:0] in1,  // Entrada 2 y 3
    input logic [7:0] in2,  // Entrada 4 y 5
    input logic [7:0] in3,  // Entrada 6 y 7
    output logic [9:0] sum, // Suma de entrada (8 bits + 1 bit signo)
    output logic all_zero   // Bandera que indica si la suma es cero
);

    // Nivel 1: sumadores A y B
    logic [7:0] sum01 = in0 + in1;  // Suma parcial entre in0 e in1
    logic [7:0] sum23 = in2 + in3; // Suma parcial entre in2 e in3

    // Nivel 2: sumador C
    logic [8:0] sum_ext0 = {1'b0, sum01}; // Extensión de signo para el sumador C
    logic [8:0] sum_ext1 = {1'b0, sum23}; // Extensión de signo para el sumador C
    logic [9:0] sum_c = sum_ext0 + sum_ext1; // Suma final

    assign sum = sum_c; // Asignar la suma final a 'sum'

    // Bandera all_zero
    assign all_zero = (sum == 0); // Verificar si la suma es cero

endmodule