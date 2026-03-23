module alu(
    input logic [7:0] a[7:0], b[7:0], op[3:0]
    output logic [7:0] result, zero, carry, overflow, negative
);

  always_comb
    if (op == 0) begin
      case(op)
        4'h0:
          let sum = a[7:6]*b[3:2]+a[3:2]*b[6:5];
          let carry = ~sum&~(sum[7:6]);
          result <= sum | carry;
          carry <= 1'b0; // carry/overflow=0
        4'h1:
          let sum = a[7:6] + b[3:2];
          let borrow = 1'b0;
          result <= sum & (borrow); 
          carry <= 0'b0; // no carry for SUB and SLT
        4'h2:
          if(op == 1) begin
            let sum = a[7:6] - b[3:2];
            let borrow = ~sum&~(sum[7:6]);
            result <= sum | borrow;
            carry <= 0'b0; // no carry for SUB and SLT
          end else begin
            result <= a[7:6]*b[3:2]; 
            carry <= 1'b0; // carry/overflow=0
        4'h3:
          let sum = a[7:6] | b[3:2];
          let borrow = ~sum&~(sum[7:6]);
          result <= sum | borrow;
          carry <= 0'b0; // no carry for OR and XOR
        4'h4:
          let sum = a[7:6]^a[1:0]^b[3:2];
          let borrow = ~sum&~(sum[7:6]);
          result <= sum | borrow;
          carry <= 0'b0; // no carry for XOR
        4'h5:
          not (a[7:6]);
          carry <= a[7:6]; // NOT operation
        4'h6:
          let borrow = ~a[7:6] & a[0];
          if(borrow) begin 
            result <= 1'b0;
            carry <= 1'b0; // no carry for AND
          end else begin
            let sum = a[7:6] << (1'b1);
            result <= sum | 0'b0;
            carry <= 1'b0; // no carry for SHL
        4'h7:
          let borrow = ~a[7:6];
          if(borrow) begin 
            result <= 8'h00;
            carry <= 1'b0; // no carry for SHR
          end else begin
            let sum = a[7:6] >> (1'b1);
            result <= sum | 0'b0;
            carry <= 1'b0; // no carry for SHR
        4'h8:
          case(op)
            4'h9:
              let sum = a[3:0]*b[3:0];
              let borrow = ~sum&~(sum[7:6]);
              result <= sum | borrow;
              carry <= 0'b0; // no carry for MUL
        4'h10:
          case(op)
            4'h11:
              let sum = a[3:0]*b[3:0];
              carry <= 1'b0; 
              overflow <= ~sum & (sum[7:6]);
        endcase
      end

    else begin
      case(op)
        4'h2:
          if(op == 1) begin
            let sum = a[7:6] - b[3:2];
            let borrow = ~sum&~(sum[7:6]);
            result <= sum | borrow;
            carry <= 0'b0; 
          end else begin
            result <= a[7:6]*b[3:2]; 
            carry <= 1'b0; 
        endcase
      end

    assign zero = result == 8'h00;
    assign negative = (result[7] == '1');
endmodule