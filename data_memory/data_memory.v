module data_memory #(
    parameter integer MEMORY_BITS = 8,
    parameter integer MEMORY_SIZE = 256
) (
    input wire clk,
    input wire write_enable,
    input wire [MEMORY_BITS-1:0] address,
    input wire [MEMORY_BITS-1:0] data_in,
    output reg [MEMORY_BITS-1:0] data_out
);

  reg [MEMORY_BITS-1:0] dram[0:MEMORY_SIZE-1];

  always @(negedge (clk)) begin
    if (write_enable == 1'b0) data_out = dram[address];
  end

  always @(posedge (clk)) begin
    if (write_enable == 1'b1) dram[address] = data_in;
  end

endmodule
