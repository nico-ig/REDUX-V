`include "utils.vh"

`timescale 1ns / 1ps

module ula_right_shift_TB ();
  reg  [`BITS-1:0] a;
  reg  [`BITS-1:0] b;
  reg  [  `OP-1:0] op;
  wire [`BITS-1:0] result;
  reg  [`BITS-1:0] expected;

  initial begin
    $dumpfile("ula_right_shift.vcd");
    $dumpvars(0, ula_right_shift_TB);
  end

  ula DUT (
      .a_in(a),
      .b_in(b),
      .op_in(op),
      .result_out(result)
  );

  initial begin
    $monitor("\ttime=%3d, op=0x%02H, a=0x%02H, b=0x%02H, result=0x%02H, expected=0x%02H", $time,
             op, a, b, result, expected);

    $display("\n### Test: right shift");
    $display("--------------------------------------------------------------------------------");
    op = 8'd7;

    for (reg [8:0] a_ = 8'd0; a_ < 9'd256; a_ = a_ + 8'd1) begin
      $display();
      a = a_;
      for (reg [8:0] b_ = 8'd0; b_ < 9'd256; b_ = b_ + 8'd1) begin
        b = b_;
        expected = a >> b;
        `ASSERT(result, expected);
      end
    end
  end
endmodule
;
