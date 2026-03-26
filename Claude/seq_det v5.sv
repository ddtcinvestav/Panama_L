module seq_det (
    input  logic clk,
    input  logic rst_n,
    input  logic data_in,
    output logic detected
);

    // PASO 2: Declaración de estados y señales
    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        S1    = 3'b001,
        S10   = 3'b010,
        S101  = 3'b011,
        S1011 = 3'b100
    } state_t;

    state_t state, next_state;

    // PASO 3: Registro de estado con reset asíncrono activo-bajo
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // PASO 4: Lógica de siguiente estado con solapamiento
    always_comb begin
        case (state)
            IDLE  : next_state = data_in ? S1    : IDLE;
            S1    : next_state = data_in ? S1    : S10;
            S10   : next_state = data_in ? S101  : IDLE;
            S101  : next_state = data_in ? S1011 : S10;
            S1011 : next_state = data_in ? S1    : S10;
            default: next_state = IDLE;
        endcase
    end

    // PASO 5: Salida Moore
    assign detected = (state == S1011);

endmodule