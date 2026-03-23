module adder_tree (
    input wire [7:0] in0, in1, in2, in3,
    output wire [9:0] sum, // 10 bits para sumar números de hasta 8 bits + carryout
    output wire all_zero
);

// Suma parcial 1: in0 + in1
wire [8:0] sum01; // Resultado de suma con carry (9 bits)
assign sum01 = in0 + in1;

// Suma parcial 2: in2 + in3
wire [8:0] sum23; // Resultado de suma con carry (9 bits)
assign sum23 = in2 + in3;

// Ahora, sumar los resultados parciales y manejar el overflow
wire [9:0] sum_final; // Suma total de ambos resultados parciales (10 bits)
assign sum_final = sum01 + sum23;

// Verificar si la suma es cero
assign all_zero = (sum_final == 0);

assign sum = sum_final; // Asignar el resultado final a "sum"

endmodule