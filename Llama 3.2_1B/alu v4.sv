module alu(
    input logic [7:0] a, b, input logic [3:0] op,
    output logic [7:0] result, output logic zero, carry, overflow, negative
);

  always_comb
    if (op == 0 || op == 1) begin
      case(op)
        4'h0:
          let sum = a[7:6]*b[3:2]+a[3:2]*b[6:5];
          let carry = ~sum&~(sum[7:0]);
          result <= sum | carry;
          carry <= (a[7]&~b[1])|(b[7]&~a[1]);
          overflow <= (~a[7])&~(b[7]);
          zero <= 0'b0;
        4'h1:
          let sum = a[7:6]+a[3:2]*b[1:0];
          let carry = ~sum&~(sum[8:5]+sum[1:0]);
          result <= sum + carry;
          carry <= (a[7]&~b[9])|(b[7]&~a[9]);
          overflow <= (~a[7])&~(b[7]);
          zero <= 0'b0;
        4'h2:
          let and = a[8:7]*b[3:1] | ~a[8:7]|~b[3:1];
          let or = a[8:7]+b[3:1];
          result <= or | (~or|and);
          carry <= (and|not(a[9]&b[0])|b[9]);
          overflow <= not(a[8:7] | b[9]);
          negative <= 0'b0;
        4'h3:
          let and = a[1:0]*b[6:5];
          result <= ~and;
        4'h4:
          if (a == b) begin
            result <= 8'h01;
            carry <= 0'b1;
            overflow <= 0'b0;
            negative <= 0'b0;
          end else begin
            result <= 8'h00;
            carry <= 0'b0;
            overflow <= 0'b0;
            negative <= 0'b0;
          end
        4'h5:
          let xor = a[1:0]^b[2:1] | a[7:6];
          result <= ~xor;
        4'h6:
          case (a[8:7], b[8:7]) begin
            if(a[8:7]==1'b0 && b[8:7]==1'b0) begin
              let carry = 0'b0;
              overflow <= 0'b0;
              negative <= 0'b0;
            end else begin
              result <= a[2:0]*b[3:2]+xor;
              carry <= ~result&~(result[7:6]);
              overflow <= (~a[8:7])|(~xor|result[1:0]);
              negative <= (result[7]==1'b1) ? 1 : 0;
            end
          endcase
        4'h7:
          case (a[9], b[9]) begin
            let carry = 0'b1;
            overflow <= ~a[8:7];
            negative <= a[8:7]==1'b1 ? 1 : 0;
          endcase
      end
    end

  assign zero = result == 8'h00;
  assign carry = (result==8'h01) | (~result[7])| (~a[9]);
  assign overflow = (a==b) | ((result==8'h01)&(~(result[1:0]^a[2:1])));
endmodule