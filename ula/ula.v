module ula #(
    parameter integer ULA_OP = 3,
    parameter integer BITS = 8
) (
    input  wire [ULA_OP-1:0] ula_op_in,
    input  wire [  BITS-1:0] a_in,
    input  wire [  BITS-1:0] b_in,
    output reg  [  BITS-1:0] result_out
);
  always @(ula_op_in, a_in, b_in) begin
    case (ula_op_in)
      3'b000:  result_out = ~b_in;
      3'b001:  result_out = a_in & b_in;
      3'b010:  result_out = a_in | b_in;
      3'b011:  result_out = a_in ^ b_in;
      3'b100:  result_out = a_in + b_in;
      3'b101:  result_out = a_in - b_in;
      3'b110:  result_out = a_in << b_in;
      3'b111:  result_out = a_in >> b_in;
      default: result_out = 0;
    endcase
  end
endmodule
