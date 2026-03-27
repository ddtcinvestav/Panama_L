`timescale 1ns/1ps

module seq_det(input logicclk, input logicrst_n, input data_in, output logic detected, 
              output reg f0, output reg f1, output reg detected_flag);

    input logic rst_n;
    input logicclk;
    input data_in;
    output logic detected;
    output reg f0;
    output reg f1;
    output reg detected_flag;

    initial 
    f0 = 0;
    f1 = 0;
    detected = false;

    always 
    if (rst_n) 
    {
        f0 = 0;
        f1 = 0;
        detected = false;
    }

    always
    if (f0 == 1 && f1 == 0 && f0 == 1 && f1 == 1)
    {
        detected = true;
    }

    always
    if (f0 == 1 && f1 == 0 && f0 == 1 && f1 == 1)
    {
        detected = true;
    }

endmodule