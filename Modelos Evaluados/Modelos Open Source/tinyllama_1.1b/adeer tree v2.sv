`timescale 1ns/1ps

// Módulo `adder_tree` que suma 4 números de 8 bits con un árbol de sumadores de dos niveles

import Verilog_HDL::*;

// Declaración de las variables de entrada
(* synthesize *)
module mkAdderTree(Empty);
    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum <- mkReg(0);
    Reg#(Bit#(1)) all_zero <- mkReg(0);

    // Declaración de las variables de entrada
    Reg#(Bit#(9)) in0 <- mkReg(0);
    Reg#(Bit#(9)) in1 <- mkReg(0);
    Reg#(Bit#(9)) in2 <- mkReg(0);
    Reg#(Bit#(9)) in3 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_1 <- mkReg(0);
    Reg#(Bit#(10)) sum_2 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_3 <- mkReg(0);
    Reg#(Bit#(10)) sum_4 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_5 <- mkReg(0);
    Reg#(Bit#(10)) sum_6 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_7 <- mkReg(0);
    Reg#(Bit#(10)) sum_8 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_9 <- mkReg(0);
    Reg#(Bit#(10)) sum_10 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_11 <- mkReg(0);
    Reg#(Bit#(10)) sum_12 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_13 <- mkReg(0);
    Reg#(Bit#(10)) sum_14 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_15 <- mkReg(0);
    Reg#(Bit#(10)) sum_16 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_17 <- mkReg(0);
    Reg#(Bit#(10)) sum_18 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_19 <- mkReg(0);
    Reg#(Bit#(10)) sum_20 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_21 <- mkReg(0);
    Reg#(Bit#(10)) sum_22 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_23 <- mkReg(0);
    Reg#(Bit#(10)) sum_24 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_25 <- mkReg(0);
    Reg#(Bit#(10)) sum_26 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_27 <- mkReg(0);
    Reg#(Bit#(10)) sum_28 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_29 <- mkReg(0);
    Reg#(Bit#(10)) sum_30 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_31 <- mkReg(0);
    Reg#(Bit#(10)) sum_32 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_33 <- mkReg(0);
    Reg#(Bit#(10)) sum_34 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_35 <- mkReg(0);
    Reg#(Bit#(10)) sum_36 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_37 <- mkReg(0);
    Reg#(Bit#(10)) sum_38 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_39 <- mkReg(0);
    Reg#(Bit#(10)) sum_40 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_41 <- mkReg(0);
    Reg#(Bit#(10)) sum_42 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_43 <- mkReg(0);
    Reg#(Bit#(10)) sum_44 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_45 <- mkReg(0);
    Reg#(Bit#(10)) sum_46 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_47 <- mkReg(0);
    Reg#(Bit#(10)) sum_48 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_49 <- mkReg(0);
    Reg#(Bit#(10)) sum_50 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_51 <- mkReg(0);
    Reg#(Bit#(10)) sum_52 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_53 <- mkReg(0);
    Reg#(Bit#(10)) sum_54 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_55 <- mkReg(0);
    Reg#(Bit#(10)) sum_56 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_57 <- mkReg(0);
    Reg#(Bit#(10)) sum_58 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_59 <- mkReg(0);
    Reg#(Bit#(10)) sum_60 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_61 <- mkReg(0);
    Reg#(Bit#(10)) sum_62 <- mkReg(0);

    // Declaración de las variables de salida
    Reg#(Bit#(10)) sum_63 <- mkReg(0);

    // Declaración de las variables de salida
    // Declaración debería sería
    // Declaración de salida
    // Declaración
    // Declaración de salida
    // Suma
    // Declaración de salida
    // Declarado

    //