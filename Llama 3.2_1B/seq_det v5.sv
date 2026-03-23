module seq_det(input logic clk, rst_n, data_in, output logic detected);

  // Variables de estado
  reg [7:0] state;
  always begin;
    initial state <= '3;

    // Transiciones del módulo
    always begin;
      case state,
        IDLE(000) → (state = IDLE; $display("Transición: %d", state)),
        S1(001) → (state = S1; $display("Transición: %d", state)),
        S10(010) → (state = S101; $display("Transición: %d", state)),
        S101(011) → (state = S1011; $display("Transición: %d", state)),
        S1011(100) → (state = IDLE; $display("Transición: %d", state))
      endcase
    $finish;

  // Función de salida
  always begin;
    always assign detected <= case (state when IDLE | S10 | S1011 ) 
      then '0, else '1;
    $display("Detected = %b", detected);
  endalways;

endmodule;