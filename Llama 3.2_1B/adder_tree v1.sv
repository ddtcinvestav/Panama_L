module adder_tree (
    input  [7:0] in0, // entrada 1
    input  [7:0] in1, // entrada 2
    input  [7:0] in2, // entrada 3
    output sum[9:0], // salida sum
    output all_zero  // salida all_zero
);

// Nivel 1: sum01[8:0]
reg sum01[8:0]; // declarar reg para sum01

always @*;
sum01 <= in0 | in1; // igualdad con entrada1 o entrada2
endmodule

// Nivel 2: sum[9:0]
reg sum23[8:0]; // declarar reg para sum23

always @*;
sum23 <= in2 | in3; // igualdad con entrada3
endmodule

reg all_zero; // declarar reg para all_zero

always @*;
all_zero <= (sum == 10'h000); // igualdad con salida sum y condición a1
endmodule

// Entrada 0: suma
reg suma;
// Entrada 1: suma
reg sub_suma;

// Nivel 3: suma
reg sum2[8:0]; // declarar reg para sum2

always @*;
sub_suma <= suma | sub_suma; // igualdad con entrada0 o entrada1
sum2 <= in0 | in1 | in2 | in3; // igualdad con entrada1, 2 y 3
endmodule

// Nivel 4: all_zero
reg all_one;
// Entrada 5: all_zero
reg sub_all_zero;

// Nivel 4 (Alternativa)
always @*;
all_one <= all_zero | in0; // igualdad con entrada5 o salida a1
sub_all_zero <= all_zero | sub_all_zero; // igualdad con entrada3 y condición a2

endmodule