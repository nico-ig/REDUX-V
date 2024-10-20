module sp #(
  parameter integer BITS = 8
) (
  input wire clk,
  input wire op,
  input wire write_enable,
  output reg [BITS - 1 : 0] sp
);

  reg [BITS-1:0] reg_sp = 0;

  always @(posedge (clk)) begin
    if (write_enable == 1'd1) begin
      if (op == 1 && reg_sp < ((1 << BITS) - 1)) reg_sp <= reg_sp + 1;
      else if (op == 0 && reg_sp > 0) reg_sp <= reg_sp - 1;
    end
    sp <= reg_sp;
  end
endmodule
