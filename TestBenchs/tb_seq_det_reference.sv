// =============================================================================
// TESTBENCH DE REFERENCIA: Detector "1011" Moore Overlapping — iverilog 13
// Proyecto: Benchmark LLM para generación RTL automática
// Autor:    Luis Montero — CINVESTAV Guadalajara
// Versión:  1.1 (fix: eliminado input string, real'(), automatic tasks)
// =============================================================================

`timescale 1ns/1ps

module tb_seq_det_reference;

    logic clk;
    logic rst_n;
    logic data_in;
    logic detected;

    seq_det dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .data_in  (data_in),
        .detected (detected)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer tests_total  = 0;
    integer tests_passed = 0;
    integer tests_failed = 0;
    real    score_pct;

    // Aplica un bit en negedge, verifica detected en posedge siguiente
    task apply_bit;
        input      bit_in;
        input      exp_detected;
        begin
            @(negedge clk);
            data_in = bit_in;
            @(posedge clk);
            #1;
            tests_total = tests_total + 1;
            if (detected === exp_detected) begin
                $display("  PASS  bit=%b | detected=%b (exp=%b)", bit_in, detected, exp_detected);
                tests_passed = tests_passed + 1;
            end else begin
                $display("  FAIL  bit=%b | detected=%b (exp=%b)", bit_in, detected, exp_detected);
                tests_failed = tests_failed + 1;
            end
        end
    endtask

    task do_reset;
        begin
            rst_n   = 0;
            data_in = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            rst_n = 1;
            $display("  [RESET]");
        end
    endtask

    initial begin
        $display("=============================================================");
        $display(" BENCHMARK SEQ DETECTOR 1011 (Moore, Overlapping)");
        $display("=============================================================");

        rst_n   = 1;
        data_in = 0;

        // --- TEST 1: Reset asincrono ---
        $display("\n--- TEST 1: Reset asincrono ---");
        @(posedge clk); #1;
        rst_n = 0;
        #3;
        tests_total = tests_total + 1;
        if (detected === 1'b0) begin
            $display("  PASS  [ASYNC_RESET] detected=0 tras rst_n=0");
            tests_passed = tests_passed + 1;
        end else begin
            $display("  FAIL  [ASYNC_RESET] detected=%b (exp=0)", detected);
            tests_failed = tests_failed + 1;
        end
        rst_n = 1;
        @(posedge clk); #1;

        // --- TEST 2: Secuencia base 1011 ---
        $display("\n--- TEST 2: Secuencia 1-0-1-1 ---");
        do_reset();
        apply_bit(1'b1, 1'b0);  // IDLE->S1
        apply_bit(1'b0, 1'b0);  // S1->S10
        apply_bit(1'b1, 1'b0);  // S10->S101
        apply_bit(1'b1, 1'b1);  // S101->S1011 detected=1

        // --- TEST 3: Salida de S1011 ---
        $display("\n--- TEST 3: Salida de S1011 con 0 ---");
        apply_bit(1'b0, 1'b0);  // S1011->S10, detected=0

        // --- TEST 4: Overlapping 1-0-1-1-0-1-1 ---
        $display("\n--- TEST 4: Overlapping 1011011 ---");
        do_reset();
        apply_bit(1'b1, 1'b0);  // ->S1
        apply_bit(1'b0, 1'b0);  // ->S10
        apply_bit(1'b1, 1'b0);  // ->S101
        apply_bit(1'b1, 1'b1);  // ->S1011 det=1
        apply_bit(1'b0, 1'b0);  // ->S10   overlap
        apply_bit(1'b1, 1'b0);  // ->S101
        apply_bit(1'b1, 1'b1);  // ->S1011 det=1

        // --- TEST 5: Overlapping con '1' tras deteccion ---
        $display("\n--- TEST 5: Overlapping 10111011 ---");
        do_reset();
        apply_bit(1'b1, 1'b0);  // ->S1
        apply_bit(1'b0, 1'b0);  // ->S10
        apply_bit(1'b1, 1'b0);  // ->S101
        apply_bit(1'b1, 1'b1);  // ->S1011 det=1
        apply_bit(1'b1, 1'b0);  // ->S1    '1' reutilizado
        apply_bit(1'b0, 1'b0);  // ->S10
        apply_bit(1'b1, 1'b0);  // ->S101
        apply_bit(1'b1, 1'b1);  // ->S1011 det=1

        // --- TEST 6: Falsos positivos ---
        $display("\n--- TEST 6: No deteccion ---");
        do_reset();
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);  // 1010 — no detecta

        do_reset();
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b0);  // 1111 — no detecta

        do_reset();
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b0, 1'b0);  // 0000 — no detecta

        do_reset();
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);  // alternante — no detecta

        // --- TEST 7: Deteccion tras ruido ---
        $display("\n--- TEST 7: Deteccion tras ruido ---");
        do_reset();
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        // Secuencia valida:
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b1);  // detecta

        // --- TEST 8: Reset a mitad de secuencia ---
        $display("\n--- TEST 8: Reset a mitad ---");
        do_reset();
        apply_bit(1'b1, 1'b0);  // ->S1
        apply_bit(1'b0, 1'b0);  // ->S10
        do_reset();              // reset — vuelve a IDLE
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b0, 1'b0);
        apply_bit(1'b1, 1'b0);
        apply_bit(1'b1, 1'b1);  // detecta desde IDLE limpio

        // --- RESUMEN ---
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
        #100000;
        $display("ERROR: TIMEOUT");
        $finish;
    end

endmodule
