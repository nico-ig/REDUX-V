`ifndef __UTILS__
`define __UTILS__


`timescale 1fs / 1fs
`define CLK 8
`define HALF_CLK 4
`define HALF_HALF_CLK 2

`define ASSERT(signal, value) \
  #1; \
  if (signal !== value) begin \
    $fatal(0, "ASSERTION FAILED -- expected: 0x%02H, actual: 0x%02H", value, signal); \
  end \

`define BITS 8
`define OP 4
`define ULA_OP 3
`define REG_BITS 2
`define REG_SIZE 4
`define MEMORY_BITS 8
`define MEMORY_SIZE 256

`endif
