module adder_tree (
    input [7:0] in0, 
    input [7:0] in1, 
    input [7:0] in2, 
    input [7:0] in3, 
    output [9:0] sum, 
    output all_zero
);

    // Suma parcial 1: (in0 + in1)
    wire [8:0] sum01 = in0 + in1;

    // Suma parcial 2: (in2 + in3)
    wire [8:0] sum23 = in2 + in3;

    // Asegúrate de manejar el overflow al sumar las dos sumas parciales
    wire [9:0] sum_final = sum01 + sum23;

    // Verifica si la suma es cero
    assign all_zero = (sum_final == 0);

    // Asigna el resultado final a 'sum'
    assign sum = sum_final;

endmodule