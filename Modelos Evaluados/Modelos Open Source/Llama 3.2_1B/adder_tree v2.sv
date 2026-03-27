module adder_tree (
    input  [7:0] in0[7:0], // entrada 1
    input  [7:0] in1[7:0], // entrada 2
    input  [7:0] in2[7:0], // entrada 3
    output sum[9:0],  // salida sum
    output all_zero  // salida all_zero
);

reg sum01, sum23; // reg para suma de parciales

always @*;
// Suma in0+in1 (9 bits) e in2+in3 (9 bits) en paralelo
sum01 <= ((in0 + in1)[7:0]) | ((in2 + in3)[7:0]);
sum23 <= ((in0 + in2)[7:0]) | ((in1 + in3)[7:0]);

// Combinacional y salida sum
always @*;
sum <= (sum01) | (sum23);

assign all_zero = (sum == 10'h000);
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
sub_all_zero <= all_zero | sub_all_zero;

endmodule

// Entrada 6: sum y all_zero
reg suma;
reg sub_suma;
reg sum2[8:0];
reg all_zero;

always @*;
suma <= (in0 + in1 + in2 + in3) | ((sum01) | (sum23));
all_zero <= (suma == 10'h000);

endmodule