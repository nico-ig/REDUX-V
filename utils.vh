`ifndef __UTILS__
`define __UTILS__

`timescale 1ns / 1ps

`define ASSERT(signal, value) \
  #10; \
  if (signal !== value) begin \
    $display("ASSERTION FAILED in %m: expected: %b, actual is : %b", value, signal); \
    $finish; \
  end \

`define OP 3
`define BITS 8

`endif
