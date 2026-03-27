module seq_det(input logic clk, rst_n, data_in, output logic detected);

  // Estado inicial
  reg [7:0] state;
  always begin;
    initial state <= '0;

    // Transiciones del módulo
    always begin;
      case state,
        IDLE(000) → (d = '0; state = IDLE),
        S1(001) → (d = '1; state = S1),
        S10(010) → (d = '0; state = S10),
        S101(011) → (d = '0; state = S101),
        S1011(100) → (d = '1; state = S1011)
      endcase
    $finish;

  // Función de salida
  always begin;
    always assign detected <= case (state when IDLE | S10 | S1011 ) 
      then '0, else '1;
    $display("Detected = %d", detected);
  endalways;

endmodule;