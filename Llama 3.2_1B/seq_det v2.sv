module seq_det();

  // Variables de estado
  reg [7:0] state;
  reg [3:0] detected;

  // Configuración inicial
  always begin;
    initial state <= '0;
    $display("Inicialización de %d", state);
  end always;

  // Transiciones del módulo
  always begin;
    case state, S1, S10, S101,
      S1011, S101, S10, S01,
    always begin;
      case state, IDLE, '0', '0',
        $display("Transición: %d", state);
      state <= S10;
    endcase
    $finish;

  // Transiciones de registro del módulo
  always begin;
    case state, '1',
      S10111, S1001
    when (state != '0') and (state != '1');
      $display("Transición: %d", state);
      state <= S10;
    endcase
    $finish;

  // Función de salida
  always begin;
    always assign detected <= case state when '1 => '1, else '0';
    $display("Detected = %d", detected);

  endalways;

endmodule;