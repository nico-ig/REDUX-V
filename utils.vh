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

`define RA 0 
`define SE 1
`define RE 2
`define WE 3
`define J 4
`define BR 5
`define DM 6
`define RD 7
`define SP 8
`define SPR 9

`define BRZR 4'h0
`define JI 4'h1
`define LD 4'h2
`define ST 4'h3
`define ADDI 4'h4
`define PUSH 4'h5
`define POP 4'h6
`define MOV 4'h7
`define NOT 4'h8
`define AND 4'h9
`define OR 4'hA
`define XOR 4'hB
`define ADD 4'hC
`define SUB 4'hD
`define SLR 4'hE
`define SRR 4'hF

`endif
