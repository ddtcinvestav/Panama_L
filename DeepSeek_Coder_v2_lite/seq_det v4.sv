module seq_det (input logic clk, rst_n, data_in, output logic detected);
    enum {IDLE, S1, S10, S101, S1011} state;
    logic [2:0] current_state, next_state;
    
    // Register for storing the current state and clock (ff)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Combinational logic for determining the next state and output
    always_comb begin
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S10 : IDLE;
            S10:  next_state = data_in ? S101 : IDLE;
            S101: next_state = data_in ? S1011 : S10;
            S1011: next_state = data_in ? IDLE : S1;
        endcase
    end
    
    // Output logic
    assign detected = (current_state == S1011);
endmodule