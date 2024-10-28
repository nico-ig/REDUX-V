`include "utils.vh"

module redux_v_TB ();
  reg clk;
  reg [`BITS-1:0] irom[0:`MEMORY_SIZE-1];

  redux_v #( .BITS(`BITS), .OP(`OP), .ULA_OP(`ULA_OP), .REG_BITS(`REG_BITS), .REG_SIZE(`REG_SIZE), .MEMORY_BITS(`MEMORY_BITS), .MEMORY_SIZE(`MEMORY_SIZE)
  ) DUT (
    .clk(clk)
  );

  initial begin
    $readmemh("instruction_memory.rom", irom);
    $dumpfile("redux_v_TB.vcd");
    $dumpvars(3, redux_v_TB);
  end

  initial clk = 1'd0;
  always #`HALF_CLK clk = !clk;

  integer pc_cnt = 0;

  always @(clk) begin
    if (clk == 1) begin
      if (pc_cnt == `MEMORY_SIZE * 20) $finish();
      pc_cnt = pc_cnt + 1;
    end
  end

endmodule
