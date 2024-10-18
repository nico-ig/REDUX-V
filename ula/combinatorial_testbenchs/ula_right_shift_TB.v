`include "utils.vh"

module ula_right_shift_TB ();
  reg  [  `BITS-1:0] a;
  reg  [  `BITS-1:0] b;
  reg  [`ULA_OP-1:0] ula_op;
  wire [  `BITS-1:0] result;
  reg  [  `BITS-1:0] expected;

  initial begin
    $dumpfile("ula_right_shift.vcd");
    $dumpvars(0, ula_right_shift_TB);
  end

  ula #(
      .ULA_OP(`ULA_OP),
      .BITS  (`BITS)
  ) DUT (
      .a_in(a),
      .b_in(b),
      .ula_op_in(ula_op),
      .result_out(result)
  );

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H", $time, ula_op, a, b, result,
             expected);

    $display("\n### Test: right shift");
    $display("--------------------------------------------------------------------------------");
    ula_op = 8'd7;

    for (reg [8:0] a_ = 8'd0; a_ < 9'd256; a_ = a_ + 8'd1) begin
      $display();
      $display("%10s %8s %5s %7s  %8s %8s", "TIME", "ULA_OP", "A", "B", "RESULT", "EXPECTED");
      a = a_;
      for (reg [8:0] b_ = 8'd0; b_ < 9'd256; b_ = b_ + 8'd1) begin
        b = b_;
        expected = a >> b;
        `ASSERT(result, expected);
      end
    end
    $display();
    $finish();
  end
endmodule
