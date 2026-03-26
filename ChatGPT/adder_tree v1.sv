module adder_tree (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic [7:0] in2,
    input  logic [7:0] in3,
    output logic [9:0] sum,
    output logic       all_zero
);

    logic [8:0] sum01;
    logic [8:0] sum23;

    // Nivel 1
    assign sum01 = {1'b0, in0} + {1'b0, in1};
    assign sum23 = {1'b0, in2} + {1'b0, in3};

    // Nivel 2
    assign sum = {1'b0, sum01} + {1'b0, sum23};

    // Flag all_zero
    assign all_zero = (sum == 10'h000);

endmodule