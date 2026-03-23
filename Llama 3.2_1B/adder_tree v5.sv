module adder_tree (
    input [7:0] in0[7:0], // entrada 1
    input [7:0] in1[7:0], // entrada 2
    input [7:0] in2[7:0], // entrada 3
    output sum[9:0],  // salida sum
    output all_zero  // salida all_zero
);

reg sum01, sum23; // reg para suma de parciales

always @*;
// Pasar 1: Suma in0+in1 (8 bits)
sum01 <= ((in0 + in1)[7:0]) | ((in2 + in3)[7:0]);
assign sum01 = {1'b0,in0}+{1'b0,in1}; // pasar por asignación

// Pasar 2: Suma in2+in3 (8 bits)
sum23 <= ((in2 + in3)[7:0]) | ((in0 + in1)[7:0]);
assign sum23 = {1'b0,in2}+{1'b0,in3}; // pasar por asignación

// Pasar 3: Suma sum01 y sum23 en paralelo
sum <= (sum01) | (sum23);

// Pasar 4: Combinacional y salida sum
assign all_zero = (sum == 10'h000);
endmodule

module sum01(
    input [7:0] in0[7:0], // entrada 1
    output sum1[9:0] // salida suma en Nivel 1
);

reg sum1[8:0]; // reg para suma en Nivel 1

always @*;
sum1 <= (in0 | in1);
endmodule

module sum23(
    input [7:0] in2[7:0], // entrada 3
    output sum2[9:0] // salida suma en Nivel 2
);

reg sum2[8:0]; // reg para suma en Nivel 2

always @*;
sum2 <= (in2 | in3);
endmodule

module adder_tree_1(
    input [7:0] in0[7:0], // entrada 1
    output sum1[9:0] // salida suma en Nivel 1
);

reg sum1[8:0];
reg sum1_2[9:0]; // reg para suma en Nivel 1

always @*;
sum1 <= (in0 | in1);
sum1_2 <= ((in0 + in1) & 1); // pasar por asignación
endmodule

module adder_tree_2(
    input [7:0] in2[7:0], // entrada 3
    output sum2[9:0] // salida suma en Nivel 2
);

reg sum2[8:0];
reg sum2_1[9:0]; // reg para suma en Nivel 2

always @*;
sum2 <= (in2 | in3);
sum2_1 <= ((in2 + in3) & 1); // pasar por asignación
endmodule

module adder_tree(
    input logic [7:0] in0[7:0], // entrada 4
    input logic [7:0] in1[7:0], // entrada 5
    input logic [7:0] in2[7:0], // entrada 6
    output sum[9:0] // salida suma
);

reg sum[9:0];
reg sum_1[9:0]; // reg para suma en Nivel 1
reg sum_2[9:0]; // reg para suma en Nivel 2

always @*;
sum <= (in0 | in1) + (((in0 | in1) & ((in2 | in3)) >> 8)); // pasar por combinacional
sum_1 <= (in0 | in1);
sum_2 <= (in2 | in3);

endmodule

module sum01_2(
    input [7:0] in0[7:0], // entrada 1
    output sum1[9:0] // salida suma en Nivel 1
);

reg sum1[8:0];
reg sum1_2[9:0]; // reg para suma en Nivel 1

always @*;
sum1 <= (in0 | in1);
sum1_2 <= ((in0 + in1) & 1); // pasar por asignación
endmodule

module sum23_2(
    input [7:0] in2[7:0], // entrada 3
    output sum2[9:0] // salida suma en Nivel 2
);

reg sum2[8:0];
reg sum2_1[9:0]; // reg para suma en Nivel 2

always @*;
sum2 <= (in2 | in3);
sum2_1 <= ((in2 + in3) & 1); // pasar por asignación
endmodule

module all_zero_1(
    input [7:0] in[7:0], // entrada
    output all_zero // salida
);

reg all_one = (in == 10'h000);
endmodule

module adder_tree_3(
    input logic [7:0] in0[7:0], // entrada 4
    input logic [7:0] in1[7:0], // entrada 5
    input logic [7:0] in2[7:0], // entrada 6
    output all_zero // salida all_zero
);

reg sum_1[8:0]; // reg para suma en Nivel 1

always @*;
sum_1 <= (in0 | in1) + (((in0 | in1) & ((in2 | in3)) >> 8); // pasar por combinacional
all_one <= all_zero | (sum_1 == 10'h000);

endmodule