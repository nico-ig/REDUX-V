module pc #(
    parameter integer BITS = 8
) (
    input wire clk,
    input wire [BITS-1:0] next_pc,
    output reg [BITS-1:0] pc
);

  always @(posedge (clk)) begin
    pc <= next_pc;
  end
endmodule
