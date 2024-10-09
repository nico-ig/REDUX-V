`include "utils.vh"

`timescale 1ns / 1ps

module ula_TB ();
  reg  [`BITS-1:0] a;
  reg  [`BITS-1:0] b;
  reg  [  `OP-1:0] op;
  wire [`BITS-1:0] result;
  reg  [`BITS-1:0] expected;

  initial begin
    $dumpfile("ula.vcd");
    $dumpvars(0, ula_TB);
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

    $display("\n### Test: not");
    $display("--------------------------------------------------------------------------------");
    op = 8'd0;
    a = 8'bxxxx_xxxx;
    b = 8'd0;
    expected = 8'd255;
    `ASSERT(result, expected);

    b = 8'd255;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'b0101_0101;
    expected = 8'b1010_1010;
    `ASSERT(result, expected);

    $display("\n### Test: and");
    $display("--------------------------------------------------------------------------------");
    op = 8'd1;
    a = 8'd0;
    b = 8'd255;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    a = 8'd255;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    $display("\n### Test: or");
    $display("--------------------------------------------------------------------------------");
    op = 8'd2;
    a = 8'd0;
    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    b = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    a = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    $display("\n### Test: xor");
    $display("--------------------------------------------------------------------------------");
    op = 8'd3;
    a = 8'd0;
    b = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd255;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd0;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd9;
    b = 8'd1;
    expected = 8'd8;
    `ASSERT(result, expected);

    $display("\n### Test: add");
    $display("--------------------------------------------------------------------------------");
    op = 8'd4;
    a = 8'd0;
    b = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd255;
    expected = 8'd254;
    `ASSERT(result, expected);

    b = 8'd1;
    expected = 8'd0;
    `ASSERT(result, expected);

    $display("\n### Test: sub");
    $display("--------------------------------------------------------------------------------");
    op = 8'd5;
    a = 8'd0;
    b = 8'd0;
    expected = 8'd0;
    `ASSERT(result, expected);

    a = 8'd255;
    b = 8'd255;
    expected = 8'd0;
    `ASSERT(result, expected);

    b = 8'd254;
    expected = 8'd1;
    `ASSERT(result, expected);

    b = 8'd1;
    expected = 8'd254;
    `ASSERT(result, expected);

    a = 8'd0;
    b = 8'd1;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd254;
    b = 8'd255;
    expected = 8'd255;
    `ASSERT(result, expected);

    a = 8'd253;
    expected = 8'd254;
    `ASSERT(result, expected);

    $display("\n### Test: left shift");
    $display("--------------------------------------------------------------------------------");
    op = 8'd6;

    for (reg [8:0] a_ = 8'd0; a_ < 9'd256; a_ = a_ + 8'd1) begin
      $display();

      a = a_;
      expected = 8'd1;

      for (b = 8'd0; expected != 8'd0; b = b + 8'd1) begin
        expected = a << b;
        `ASSERT(result, expected);
      end

      b = 8'd255;
      expected = 8'd0;
      `ASSERT(result, expected);
    end

    $display("\n### Test: right shift");
    $display("--------------------------------------------------------------------------------");
    op = 8'd7;

    for (reg [8:0] a_ = 8'd0; a_ < 9'd256; a_ = a_ + 8'd1) begin
      $display();

      a = a_;
      expected = 8'd1;

      for (b = 8'd0; expected != 8'd0; b = b + 8'd1) begin
        expected = a >> b;
        `ASSERT(result, expected);
      end

      b = 8'd255;
      expected = 8'd0;
      `ASSERT(result, expected);
    end
  end
endmodule
;
