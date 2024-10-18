module instruction_memory #(
    parameter integer MEMORY_BITS = 8,
    parameter integer MEMORY_SIZE = 256
) (
    input wire clk,
    input wire [MEMORY_BITS-1:0] pc,
    output reg [MEMORY_BITS-1:0] instruction
);

  reg [MEMORY_BITS-1:0] irom[0:MEMORY_SIZE-1];

  initial begin
    $readmemh("instruction_memory.rom", irom);
  end

  always @(posedge (clk)) begin
    instruction = irom[pc];
  end

endmodule
