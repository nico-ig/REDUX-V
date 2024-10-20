`include "utils.vh"

module control_unit #(
    parameter integer OP = 4
) (
    input wire [OP - 1: 0] op,
    output reg [0:9] signals,
    output reg [`ULA_OP - 1: 0] ula_op
);

  wire [9 : 0] op_signals [0 : (1 << `OP)];
  wire [`ULA_OP - 1 : 0] op_ula_op [0 : (1 << `ULA_OP)];

  assign op_signals[`BRZR] = 1 << `BR;
  assign op_signals[`JI] = 1 << `J;
  assign op_signals[`LD] = (1 << `RA) | (1 << `RE) | (1 << `DM);
  assign op_signals[`ST] = 1 << `WE;
  assign op_signals[`ADDI] = (1 << `RA) | (1 << `SE) | (1 << `RE);
  assign op_signals[`PUSH] = (1 << `RA) | (1 << `RE) | (1 << `WE) | (1 << `DM) | (1 << `SP);
  assign op_signals[`POP] = (1 << `RE) | (1 << `DM) | (1 << `SP) | (1 << `SPR);
  assign op_signals[`MOV] = 1 << `RE;
  assign op_signals[`NOT] = 1 << `RE;
  assign op_signals[`AND] = 1 << `RE;
  assign op_signals[`OR] = 1 << `RE;
  assign op_signals[`XOR] = 1 << `RE;
  assign op_signals[`ADD] = 1 << `RE;
  assign op_signals[`SUB] = 1 << `RE;
  assign op_signals[`SLR] = 1 << `RE;
  assign op_signals[`SRR] = 1 << `RE;

  assign op_ula_op[`NOT & ~(1 << `ULA_OP)] = `NOT;
  assign op_ula_op[`AND & ~(1 << `ULA_OP)] = `AND;
  assign op_ula_op[`OR & ~(1 << `ULA_OP)] = `OR;
  assign op_ula_op[`XOR & ~(1 << `ULA_OP)] = `XOR;
  assign op_ula_op[`ADD & ~(1 << `ULA_OP)] = `ADD;
  assign op_ula_op[`SUB & ~(1 << `ULA_OP)] = `SUB;
  assign op_ula_op[`SLR & ~(1 << `ULA_OP)] = `SLR;
  assign op_ula_op[`SRR & ~(1 << `ULA_OP)] = `SRR;

  always @* begin
    signals = 0;
    ula_op = 0;

    signals = op_signals[op];

    if (op == `ADDI || op >= `NOT)
      ula_op = op_ula_op[op & ~(1 << `ULA_OP)];
  end
endmodule
