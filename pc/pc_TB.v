`include "utils.vh"

module pc_TB ();
  reg clk;
  reg [`BITS-1:0] next_pc;
  wire [`BITS-1:0] pc;
  reg [`BITS-1:0] expected;

  initial begin
    $dumpfile("pc.vcd");
    $dumpvars(0, pc_TB);
  end

  pc #(
      .BITS(`BITS)
  ) DUT (
      .clk(clk),
      .pc(pc),
      .next_pc(next_pc)
  );

  always #`HALF_CLK clk = !clk;

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H", $time, clk, pc, next_pc, expected);

    $display("\n### Test: pc");
    $display("--------------------------------------------------------------------------------");
    $display("%10s %7s %6s   %7s %8s", "TIME", "CLK", "PC", "NEXT_PC", "EXPECTED");
    clk = 1'd0;
    next_pc = 8'd0;
    expected = 8'd0;
  end

  always @(clk) begin
    if (clk == 1) begin
      expected = next_pc;
      `ASSERT(pc, expected);
      if (expected == 8'd255) begin
        $display();
        $finish;
      end
    end else next_pc = expected + 1;
  end

endmodule
