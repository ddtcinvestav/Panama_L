module seq_det (input logic clk, rst_n, data_in, output logic detected);
    typedef enum logic[2:0] {IDLE=3'b000, S1=3'b001, S10=3'b010, S101=3'b011, S1011=3'b100}; state_t;
    state_t state, next_state;

    // Register for storing the current state and clock (ff)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for determining the next state and output
    always_comb begin
        case (state)
            IDLE:  next_state = data_in ? S1 : IDLE;
            S1:    next_state = data_in ? S10 : IDLE;
            S10:   next_state = data_in ? S101 : IDLE;
            S101:  next_state = data_in ? S1011 : S10;
            S1011: next_state = data_in ? IDLE : S1;
        endcase
    end

    // Output logic
    assign detected = (next_state == S1011);
endmodule