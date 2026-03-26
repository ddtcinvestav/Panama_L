module seq_det (
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic detected
);

  // Definición de estados (3 bits para mapear a 3 flip-flops D)
  typedef enum logic [2:0] {
    IDLE  = 3'b000,
    S1    = 3'b001,
    S10   = 3'b010,
    S101  = 3'b011,
    S1011 = 3'b100
  } state_t;

  state_t state, next_state;

  // [REGISTRO] Lógica secuencial con Reset Asíncrono bajo
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // [NEXT STATE] Decodificador combinacional (Lógica de transición)
  always_comb begin
    case (state)
      IDLE:  next_state = (data_in) ? S1    : IDLE;
      
      S1:    next_state = (data_in) ? S1    : S10;
      
      S10:   next_state = (data_in) ? S101  : IDLE;
      
      S101:  next_state = (data_in) ? S1011 : S10;
      
      // Estado final S1011 (Moore: salida activa aquí)
      // Transiciones para solapamiento (Overlap)
      S1011: next_state = (data_in) ? S1    : S10;
      
      default: next_state = IDLE;
    endcase
  end

  // [SALIDA] Lógica de salida Moore (No depende de data_in)
  assign detected = (state == S1011);

endmodule