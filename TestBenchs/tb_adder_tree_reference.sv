// =============================================================================
// TESTBENCH DE REFERENCIA: Adder Tree 4×8 bits → 10 bits — iverilog 13
// Proyecto: Benchmark LLM para generación RTL automática
// Autor:    Luis Montero — CINVESTAV Guadalajara
// Versión:  1.1 (fix: eliminado 10'd(expr), input string, real'())
// =============================================================================

`timescale 1ns/1ps

module tb_adder_tree_reference;

    logic [7:0] in0, in1, in2, in3;
    logic [9:0] sum;

    adder_tree dut (
        .in0 (in0),
        .in1 (in1),
        .in2 (in2),
        .in3 (in3),
        .sum (sum)
    );

    integer tests_total  = 0;
    integer tests_passed = 0;
    integer tests_failed = 0;
    real    score_pct;

    task check;
        input [127:0] test_name;
        input [9:0]   exp_sum;
        begin
            #1;
            tests_total = tests_total + 1;
            if (sum === exp_sum) begin
                $display("  PASS  in0=%0d in1=%0d in2=%0d in3=%0d | sum=%0d (exp=%0d)",
                         in0, in1, in2, in3, sum, exp_sum);
                tests_passed = tests_passed + 1;
            end else begin
                $display("  FAIL  in0=%0d in1=%0d in2=%0d in3=%0d | sum=%0d (exp=%0d)",
                         in0, in1, in2, in3, sum, exp_sum);
                tests_failed = tests_failed + 1;
            end
        end
    endtask

    initial begin
        $display("=============================================================");
        $display(" BENCHMARK ADDER TREE 4x8 bits");
        $display("=============================================================");

        $display("\n--- Casos base ---");
        in0=0;     in1=0;     in2=0;     in3=0;     check("ALL_ZERO",    10'd0);
        in0=1;     in1=1;     in2=1;     in3=1;     check("ALL_ONE",     10'd4);
        in0=8'hFF; in1=0;     in2=0;     in3=0;     check("ONLY_IN0",    10'd255);
        in0=0;     in1=8'hFF; in2=0;     in3=0;     check("ONLY_IN1",    10'd255);
        in0=0;     in1=0;     in2=8'hFF; in3=0;     check("ONLY_IN2",    10'd255);
        in0=0;     in1=0;     in2=0;     in3=8'hFF; check("ONLY_IN3",    10'd255);

        $display("\n--- Valores maximos ---");
        in0=8'hFF; in1=8'hFF; in2=8'hFF; in3=8'hFF; check("MAX_ALL",    10'd1020);
        in0=8'hFF; in1=8'hFF; in2=0;     in3=0;     check("MAX_TWO",    10'd510);
        in0=8'hFF; in1=8'hFF; in2=8'hFF; in3=0;     check("MAX_THREE",  10'd765);

        $display("\n--- Simetria ---");
        // 0x10+0x20+0x30+0x40 = 16+32+48+64 = 160
        in0=8'h10; in1=8'h20; in2=8'h30; in3=8'h40; check("SYM_ABCD", 10'd160);
        in0=8'h40; in1=8'h30; in2=8'h20; in3=8'h10; check("SYM_DCBA", 10'd160);
        in0=8'h20; in1=8'h10; in2=8'h40; in3=8'h30; check("SYM_BADC", 10'd160);

        $display("\n--- Carry nivel 1 ---");
        in0=8'hFF; in1=8'h01; in2=8'h00; in3=8'h00; check("CARRY_PAIR01",   10'd256);
        in0=8'h00; in1=8'h00; in2=8'hFF; in3=8'h01; check("CARRY_PAIR23",   10'd256);
        in0=8'hFF; in1=8'hFF; in2=8'hFF; in3=8'hFF; check("CARRY_BOTH",     10'd1020);

        $display("\n--- Valores variados ---");
        // 100+200+50+75 = 425
        in0=8'd100; in1=8'd200; in2=8'd50;  in3=8'd75;  check("MIXED_1",    10'd425);
        // 0xAA+0x55+0xAA+0x55 = 170+85+170+85 = 510
        in0=8'hAA;  in1=8'h55;  in2=8'hAA;  in3=8'h55;  check("ALT_PATTERN",10'd510);
        // 1+2+4+8 = 15
        in0=8'h01;  in1=8'h02;  in2=8'h04;  in3=8'h08;  check("POWERS_2",   10'd15);
        // 128*4 = 512
        in0=8'h80;  in1=8'h80;  in2=8'h80;  in3=8'h80;  check("MSB_ALL",    10'd512);
        // 200*4 = 800
        in0=8'd200; in1=8'd200; in2=8'd200; in3=8'd200; check("OVER_9BIT",  10'd800);
        // 255+255+255+0 = 765
        in0=8'd255; in1=8'd255; in2=8'd255; in3=8'd0;   check("THREE_MAX",  10'd765);

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
        #5000;
        $display("ERROR: TIMEOUT");
        $finish;
    end

endmodule
