`include "utils.vh"

module sp_TB ();
  reg clk;
  reg write_enable;
  reg op;
  wire [`BITS-1:0] sp;
  reg [`BITS-1:0] expected;

  initial begin
    $dumpfile("sp.vcd");
    $dumpvars(0, sp_TB);
  end

  sp #(
      .BITS(`BITS)
  ) DUT (
      .clk(clk),
      .write_enable(write_enable),
      .op(op),
      .sp(sp)
  );

  always #`HALF_CLK clk = !clk;

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H", $time, clk, write_enable, op, sp, expected);

    $display("\n### Test: stack pointer");
    $display("-------------------------------------------------------------------------------------------------");
    $display("%10s %7s %6s %7s %7s   %8s", "TIME", "CLK", "WE", "OP", "SP", "EXPECTED");

    clk = 1'd0;
    write_enable = 1'd0;
    op = 1'd1;
    expected = 8'd0;
  end

  integer cnt = 0;

  always @(clk) begin
    if (clk == 1) begin
        if (write_enable == 1'd1 && cnt >= 3) begin
            expected = op == 1'd1 ? expected + 1 : expected - 1;
          if (expected == 8'd0 && op == 1'd1) begin
            expected = expected - 1;
            op = !op;
            $display();
            $display("%10s %7s %6s %7s %7s   %8s", "TIME", "CLK", "WE", "OP", "SP", "EXPECTED");
          end else if (expected == 8'd0 && op == 1'd0) begin
            $display();
            $finish;
          end
      end
      write_enable = !write_enable;
    end else begin
      `ASSERT(sp, expected);
      cnt = cnt + 1;
    end

  end
endmodule
