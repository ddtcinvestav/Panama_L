// =============================================================================
// TESTBENCH DE REFERENCIA: ALU 8 bits — compatible iverilog 13
// Proyecto: Benchmark LLM para generación RTL automática
// Autor:    Luis Montero — CINVESTAV Guadalajara
// Versión:  1.1 (fix: eliminado real'(), input string, 8'hxx)
// =============================================================================

`timescale 1ns/1ps

module tb_alu_reference;

    logic [7:0] a, b;
    logic [3:0] op;
    logic [7:0] result;
    logic       zero, carry, overflow, negative;

    alu dut (
        .a        (a),
        .b        (b),
        .op       (op),
        .result   (result),
        .zero     (zero),
        .carry    (carry),
        .overflow (overflow),
        .negative (negative)
    );

    integer tests_total  = 0;
    integer tests_passed = 0;
    integer tests_failed = 0;
    real    score_pct;

    task check;
        input [127:0] test_name;
        input [7:0]   exp_result;
        input         exp_zero, exp_carry, exp_overflow, exp_negative;
        begin
            #1;
            tests_total = tests_total + 1;
            if (result   === exp_result   &&
                zero     === exp_zero     &&
                carry    === exp_carry    &&
                overflow === exp_overflow &&
                negative === exp_negative)
            begin
                $display("  PASS  a=%02h b=%02h op=%0d | res=%02h z=%b c=%b ov=%b n=%b",
                         a, b, op, result, zero, carry, overflow, negative);
                tests_passed = tests_passed + 1;
            end
            else begin
                $display("  FAIL  a=%02h b=%02h op=%0d", a, b, op);
                $display("        GOT: res=%02h z=%b c=%b ov=%b n=%b",
                         result, zero, carry, overflow, negative);
                $display("        EXP: res=%02h z=%b c=%b ov=%b n=%b",
                         exp_result, exp_zero, exp_carry, exp_overflow, exp_negative);
                tests_failed = tests_failed + 1;
            end
        end
    endtask

    initial begin
        $display("=============================================================");
        $display(" BENCHMARK ALU 8 bits");
        $display("=============================================================");

        $display("\n--- ADD (op=0) ---");
        a=8'h10; b=8'h20; op=4'd0; check("ADD_normal",  8'h30, 0,0,0,0);
        a=8'h00; b=8'h00; op=4'd0; check("ADD_zero",    8'h00, 1,0,0,0);
        a=8'hFF; b=8'h01; op=4'd0; check("ADD_carry",   8'h00, 1,1,0,0);
        a=8'h7F; b=8'h01; op=4'd0; check("ADD_ovf_pos", 8'h80, 0,0,1,1);
        a=8'h80; b=8'h80; op=4'd0; check("ADD_ovf_neg", 8'h00, 1,1,1,0);
        a=8'hA0; b=8'h05; op=4'd0; check("ADD_neg",     8'hA5, 0,0,0,1);

        $display("\n--- SUB (op=1) ---");
        a=8'h50; b=8'h20; op=4'd1; check("SUB_normal", 8'h30, 0,0,0,0);
        a=8'h55; b=8'h55; op=4'd1; check("SUB_zero",   8'h00, 1,0,0,0);
        a=8'h00; b=8'h01; op=4'd1; check("SUB_borrow", 8'hFF, 0,1,0,1);
        a=8'h80; b=8'h01; op=4'd1; check("SUB_ovf",    8'h7F, 0,0,1,0);

        $display("\n--- AND (op=2) ---");
        a=8'hF0; b=8'hAA; op=4'd2; check("AND_normal", 8'hA0, 0,0,0,1);
        a=8'hFF; b=8'h00; op=4'd2; check("AND_zero",   8'h00, 1,0,0,0);
        a=8'hFF; b=8'hFF; op=4'd2; check("AND_ones",   8'hFF, 0,0,0,1);

        $display("\n--- OR (op=3) ---");
        a=8'hF0; b=8'h0F; op=4'd3; check("OR_normal",     8'hFF, 0,0,0,1);
        a=8'h00; b=8'h00; op=4'd3; check("OR_zero",        8'h00, 1,0,0,0);
        a=8'hAA; b=8'h55; op=4'd3; check("OR_alternating", 8'hFF, 0,0,0,1);

        $display("\n--- XOR (op=4) ---");
        a=8'hFF; b=8'hFF; op=4'd4; check("XOR_same",        8'h00, 1,0,0,0);
        a=8'hAA; b=8'h55; op=4'd4; check("XOR_alternating", 8'hFF, 0,0,0,1);
        a=8'hF0; b=8'h0F; op=4'd4; check("XOR_nibble",      8'hFF, 0,0,0,1);

        $display("\n--- NOT (op=5) ---");
        a=8'hFF; b=8'h00; op=4'd5; check("NOT_ones",    8'h00, 1,0,0,0);
        a=8'h00; b=8'h00; op=4'd5; check("NOT_zero",    8'hFF, 0,0,0,1);
        a=8'hAA; b=8'h00; op=4'd5; check("NOT_pattern", 8'h55, 0,0,0,0);

        $display("\n--- SHL (op=6) ---");
        a=8'h01; b=8'h00; op=4'd6; check("SHL_one",       8'h02, 0,0,0,0);
        a=8'h80; b=8'h00; op=4'd6; check("SHL_msb_carry", 8'h00, 1,1,0,0);
        a=8'hAA; b=8'h00; op=4'd6; check("SHL_pattern",   8'h54, 0,1,0,0);
        a=8'h2A; b=8'h00; op=4'd6; check("SHL_no_carry",  8'h54, 0,0,0,0);

        $display("\n--- SHR (op=7) ---");
        a=8'h02; b=8'h00; op=4'd7; check("SHR_two",       8'h01, 0,0,0,0);
        a=8'h01; b=8'h00; op=4'd7; check("SHR_lsb_carry", 8'h00, 1,1,0,0);
        a=8'hAA; b=8'h00; op=4'd7; check("SHR_pattern",   8'h55, 0,0,0,0);
        a=8'hFF; b=8'h00; op=4'd7; check("SHR_ff",        8'h7F, 0,1,0,0);

        $display("\n--- SLT (op=8) ---");
        a=8'h05; b=8'h0A; op=4'd8; check("SLT_true",  8'h01, 0,0,0,0);
        a=8'h0A; b=8'h05; op=4'd8; check("SLT_false", 8'h00, 1,0,0,0);
        a=8'h07; b=8'h07; op=4'd8; check("SLT_equal", 8'h00, 1,0,0,0);
        a=8'h00; b=8'hFF; op=4'd8; check("SLT_max",   8'h01, 0,0,0,0);

        $display("\n--- MUL nibble (op=9) ---");
        a=8'h03; b=8'h04; op=4'd9; check("MUL_3x4",        8'h0C, 0,0,0,0);
        a=8'h0F; b=8'h0F; op=4'd9; check("MUL_F_x_F",      8'hE1, 0,0,0,1);
        a=8'h07; b=8'h00; op=4'd9; check("MUL_by_zero",     8'h00, 1,0,0,0);
        a=8'h01; b=8'h01; op=4'd9; check("MUL_1x1",         8'h01, 0,0,0,0);
        a=8'hF3; b=8'hA4; op=4'd9; check("MUL_ignore_high", 8'h0C, 0,0,0,0);

        $display("\n--- NOP (op>=10) ---");
        a=8'hFF; b=8'hFF; op=4'd10; check("NOP_10", 8'h00, 1,0,0,0);
        a=8'hAB; b=8'hCD; op=4'd15; check("NOP_15", 8'h00, 1,0,0,0);

        $display("\n=============================================================");
        $display(" RESUMEN FINAL");
        $display("   Total  : %0d", tests_total);
        $display("   PASSED : %0d", tests_passed);
        $display("   FAILED : %0d", tests_failed);
        score_pct = (tests_total > 0) ? (tests_passed * 100.0 / tests_total) : 0.0;
        $display("   Score  : %.1f%%", score_pct);
        $display("=============================================================");
        if (tests_failed == 0)
            $display(" RESULTADO: ALL TESTS PASSED");
        else
            $display(" RESULTADO: %0d TEST(S) FAILED", tests_failed);
        $finish;
    end

    initial begin
        #50000;
        $display("ERROR: TIMEOUT");
        $finish;
    end

endmodule
