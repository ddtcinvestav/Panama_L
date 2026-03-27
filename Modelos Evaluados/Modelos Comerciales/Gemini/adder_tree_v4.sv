module adder_tree (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic [7:0] in2,
    input  logic [7:0] in3,
    output logic [9:0] sum,
    output logic       all_zero
);

    // Señales internas para el Nivel 1 (9 bits)
    logic [8:0] sum01;
    logic [8:0] sum23;

    // --- NIVEL 1 ---
    // Sumadores A y B con Zero-extension a 9 bits para evitar desbordamiento
    assign sum01 = {1'b0, in0} + {1'b0, in1};
    assign sum23 = {1'b0, in2} + {1'b0, in3};

    // --- NIVEL 2 ---
    // Sumador C con Zero-extension a 10 bits para el resultado final
    assign sum = {1'b0, sum01} + {1'b0, sum23};

    // --- BANDERA ---
    // Comparación lógica para detectar si el total es cero
    assign all_zero = (sum == 10'd0);

endmodule