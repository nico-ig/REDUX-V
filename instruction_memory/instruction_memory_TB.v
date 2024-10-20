`include "utils.vh"

module instruction_memory_TB ();

  integer memory_file;
  reg [`BITS-1:0] data;
  reg [`BITS-1:0] irom_TB[0:`MEMORY_SIZE-1];

  reg clk;
  reg [`BITS-1:0] pc;
  wire [`BITS-1:0] instruction;

  instruction_memory #(
      .MEMORY_BITS(`MEMORY_BITS),
      .MEMORY_SIZE(`MEMORY_SIZE)
  ) DUT (
      .clk(clk),
      .pc(pc),
      .instruction(instruction)
  );

  initial begin
    memory_file = $fopen("instruction_memory.rom", "r");

    if (memory_file == 0) begin
      memory_file = $fopen("instruction_memory.rom", "w+");
      for (reg [8:0] i = 9'd0; i != 9'd256; i++) begin
        data = i;
        $fdisplayh(memory_file, data);
      end
      $fclose(memory_file);
      $display("File instruction_memory.rom created, testbench must be re-run.");
      $finish();
    end

    $fclose(memory_file);
    $readmemh("instruction_memory.rom", irom_TB);
  end

  initial begin
    $dumpfile("instruction_memory_TB.vcd");
    $dumpvars(0, instruction_memory_TB);
  end

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H      0x%02H", $time, clk, pc, instruction,
             data);

    $display("\n### Test: instruction memory");
    $display("--------------------------------------------------------------------------------");
    $display("%10s %7s %6s %8s %7s", "TIME", "CLK", "PC", "INSTRUCTION", "EXPECTED");

    clk = 1'd0;
    pc = 8'd255;
  end

  always #`HALF_CLK clk = !clk;

  always @(clk) begin
    if (clk == 1'd0) begin
      pc = pc + 1'd1;
      data = irom_TB[pc];
  end else begin
    `ASSERT(instruction, data);
    if (pc == 8'd255) begin
      $display();
      $finish();
    end
  end
  end
endmodule
