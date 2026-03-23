`timescale 1ns/1ps

module mkAdder_Tree#(In0 in0_ifc, In1 in1_ifc, In2 in2_ifc, In3 in3_ifc, Sum sum_ifc, All_Zero all_zero_ifc, Sum01 sum01_ifc, Sum23 sum23_ifc)(Adder_Tree);
    // Connect input signals
    rule connect_inputs;
        in0_ifc.in0 <= in0.in0;
        in1_ifc.in1 <= in1.in1;
        in2_ifc.in2 <= in2.in2;
        in3_ifc.in3 <= in3.in3;
    endrule

    // Connect internal signals
    rule connect_internal_signals;
        sum_ifc.sum_in0 <= sum_ifc.sum_in0 + sum_ifc.sum_in1;
        sum_ifc.sum_in1 <= sum_ifc.sum_in0 + sum_ifc.sum_in2;
        sum_ifc.sum_in2 <= sum_ifc.sum_in1 + sum_ifc.sum_in3;
        sum_ifc.sum <= sum_ifc.sum_in0 + sum_ifc.sum_in1 + sum_ifc.sum_in2 + sum_ifc.sum_in3;
    endrule

    // Connect output signals
    rule connect_outputs;
        sum_ifc.sum <= sum_ifc.sum_in0 + sum_ifc.sum_in1 + sum_ifc.sum_in2 + sum_ifc.sum_in3;
        all_zero_ifc.all_zero <= all_zero_ifc.all_zero;
        sum01_ifc.sum01 <= sum_ifc.sum_in01;
        sum23_ifc.sum23 <= sum_ifc.sum_in23;
    endrule

    // Connect reloj
    rule connect_reloj;
        $display("[%0d] Adder_Tree: reloj", $time);
    endrule

    // Connect synthesizable code
    interface In0 in0;
        method ActionValue#(Bit#(8)) in0;
            in0_ifc.in0 <= in0_ifc.in0;
        endmethod
    endinterface
    interface In1 in1;
        method ActionValue#(Bit#(8)) in1;
            in1_ifc.in1 <= in1_ifc.in1;
        endmethod
    endinterface
    interface In2 in2;
        method ActionValue#(Bit#(8)) in2;
            in2_ifc.in2 <= in2_ifc.in2;
        endmethod
    endinterface
    interface In3 in3;
        method ActionValue#(Bit#(8)) in3;
            in3_ifc.in3 <= in3_ifc.in3;
        endmethod
    endinterface
    interface Sum sum;
        method ActionValue#(Bit#(9)) sum;
            sum_ifc.sum <= sum_ifc.sum_in0 + sum_ifc.sum_in1 + sum_ifc.sum_in2 + sum_ifc.sum_in3;
        endmethod
    endinterface
    interface All_Zero all_zero;
        method Action all_zero;
            all_zero_ifc.all_zero;
        endmethod
    endinterface
    interface Sum01 sum01;
        method ActionValue#(Bit#(8)) sum01;
            sum01_ifc.sum01 <= sum_ifc.sum_in01;
        endmethod
    endinterface
    interface Sum23 sum23;
        method ActionValue#(Bit#(8)) sum23;
            sum23_ifc.sum23 <= sum_ifc.sum_in23;
        endmethod
    endinterface
endmodule