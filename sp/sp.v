module sp #(
  parameter integer BITS = 8
) (
  input wire clk,
  input wire op,
  input wire write_enable,
  output reg [BITS - 1 : 0] sp
);

  initial sp = 0;
  reg [BITS:0] reg_sp = 0;
  always @(posedge (clk)) sp = reg_sp === {BITS{1'd0}} ? reg_sp : (reg_sp - 1'd1) & {BITS{1'd1}};

  always @(negedge (clk)) begin
    if (write_enable) begin
      if (op && reg_sp <= ((1'd1 << BITS) - 1'd1)) reg_sp = reg_sp + 1'd1;
      else if (!op && reg_sp > 1'd0) reg_sp = reg_sp - 1'd1;
    end
  end
endmodule
