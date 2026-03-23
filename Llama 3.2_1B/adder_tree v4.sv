module adder_tree (
    input [7:0] in0[7:0], // entrada 1
    input [7:0] in1[7:0], // entrada 2
    input [7:0] in2[7:0], // entrada 3
    output sum[9:0],  // salida sum
    output all_zero  // salida all_zero
);

reg sum01, sum23; // reg para suma de parciales

always @*;
// Suma in0+in1 (8 bits)
sum01 <= ((in0 + in1)[7:0]) | ((in2 + in3)[7:0]);

// Combinacional y salida sum
always @*;
sum <= (sum01) | (sum23);

assign all_zero = (sum == 10'h000);
endmodule

// Entrada 0: suma
reg suma1, suma2[8:0]; // declarar reg para suma en Nivel 1
reg suma3[8:0]; // declarar reg para suma en Nivel 2

always @*;
suma1 <= (in0 + in1);
suma2 <= (in2 + in3);
suma3 <= ((in0 + in1) | (in2 + in3));
endmodule

// Nivel 2: suma
reg sum23[8:0]; // reg para suma de parciales en Nivel 2

always @*;
sum23 <= (suma1 | suma2);

endmodule

// Entrada 4: suma y all_zero
reg suma4, suma5[9:0];
reg all_one_4; // declarar reg para all_zero en Nivel 4

always @*;
suma4 <= (in0 + in1 + in2 + in3) | ((suma23) & 1);
all_one_4 <= all_zero | (suma4 == 10'h000);

endmodule