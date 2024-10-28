`include "utils.vh"

module control_unit #(
    parameter integer OP = 4,
    parameter integer ULA_OP = 3
) (
    input wire [OP - 1: 0] op,
    output reg [`SPR : 0] signals,
    output reg [ULA_OP - 1: 0] ula_op
);
  wire [`SPR : 0] op_signals [0 : (1 << OP)];

  assign op_signals[`BRZR] = (1 << `BR) | (1 << `RA);
  assign op_signals[`JI] = 1 << `J;
  assign op_signals[`LD] = (1 << `RA) | (1 << `RE) | (1 << `DM);
  assign op_signals[`ST] = 1 << `WE;
  assign op_signals[`ADDI] = (1 << `SE) | (1 << `RE);
  assign op_signals[`PUSH] = (1 << `RA) | (1 << `RE) | (1 << `WE) | (1 << `DM) | (1 << `SP) | (1 << `SPR);
  assign op_signals[`POP] = (1 << `RA) |(1 << `RE) | (1 << `DM) | (1 << `SP);
  assign op_signals[`MOV] = (1 << `RA) | (1 << `RE) | (1 << `RD);
  assign op_signals[`NOT] = (1 << `RA) | (1 << `RE);
  assign op_signals[`AND] = (1 << `RA) | (1 << `RE);
  assign op_signals[`OR] = (1 << `RA) | (1 << `RE);
  assign op_signals[`XOR] = (1 << `RA) | (1 << `RE);
  assign op_signals[`ADD] = (1 << `RA) | (1 << `RE);
  assign op_signals[`SUB] = (1 << `RA) | (1 << `RE);
  assign op_signals[`SLR] = (1 << `RA) | (1 << `RE);
  assign op_signals[`SRR] = (1 << `RA) | (1 << `RE);

  always @* begin
    signals = op_signals[op];
    ula_op = op & 3'b111;
  end

endmodule
