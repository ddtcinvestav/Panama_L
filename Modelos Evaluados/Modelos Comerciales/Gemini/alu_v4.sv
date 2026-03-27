// COMPONENTE: alu
// ESTÁNDAR: IEEE 1800-2017
// ESTILO: RTL Combinacional Modular

module alu (
    input  logic [7:0] a, b,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry,
    output logic       overflow,
    output logic       negative
);

    // --- SEÑALES INTERNAS DE BLOQUES ---
    logic [7:0] res_arith, res_logic, res_shift, res_comp, res_mult;
    logic       c_arith, v_arith, c_shift;
    logic [8:0] sum_res; // 9 bits para capturar el carry de suma/resta

    // --- [1] UNIDAD ARITMÉTICA (op 0, 1) ---
    always_comb begin
        if (op == 4'h0) begin // Suma
            sum_res  = a + b;
            res_arith = sum_res[7:0];
            c_arith   = sum_res[8];
            v_arith   = (~a[7] & ~b[7] & res_arith[7]) | (a[7] & b[7] & ~res_arith[7]);
        end else begin        // Resta (op 1)
            sum_res  = a - b;
            res_arith = sum_res[7:0];
            c_arith   = sum_res[8];
            v_arith   = (~a[7] & b[7] & res_arith[7]) | (a[7] & ~b[7] & ~res_arith[7]);
        end
    end

    // --- [2] UNIDAD LÓGICA (op 2-5) ---
    always_comb begin
        case (op)
            4'h2:    res_logic = a & b; // AND
            4'h3:    res_logic = a | b; // OR
            4'h4:    res_logic = a ^ b; // XOR
            4'h5:    res_logic = ~a;    // NOT
            default: res_logic = 8'h00;
        endcase
    end

    // --- [3] SHIFTER (op 6, 7) ---
    always_comb begin
        if (op == 4'h6) begin      // SHL
            c_shift   = a[7];
            res_shift = {a[6:0], 1'b0};
        end else begin             // SHR (op 7)
            c_shift   = a[0];
            res_shift = {1'b0, a[7:1]};
        end
    end

    // --- [4] COMPARADOR (op 8) ---
    assign res_comp = (a < b) ? 8'h01 : 8'h00;

    // --- [5] MULTIPLICADOR (op 9) ---
    assign res_mult = a[3:0] * b[3:0];

    // --- [6] MUX DE SALIDA Y [7] FLAGS ---
    always_comb begin
        // Valores por defecto
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        case (op)
            4'h0, 4'h1: begin // Aritmética
                result   = res_arith;
                carry    = c_arith;
                overflow = v_arith;
            end
            4'h2, 4'h3, 
            4'h4, 4'h5: begin // Lógica
                result   = res_logic;
            end
            4'h6, 4'h7: begin // Shifter
                result   = res_shift;
                carry    = c_shift;
            end
            4'h8: begin       // Comparador
                result   = res_comp;
            end
            4'h9: begin       // Multiplicador
                result   = res_mult;
            end
            default: result = 8'h00; // NOP
        endcase
    end

    // Flags globales derivados del resultado final
    assign zero     = (result == 8'h00);
    assign negative = result[7];

endmodule