`include "utils.vh"

module control_unit_TB ();
    reg [`OP - 1 : 0] op;
    wire [0:9] signals;
    wire [`ULA_OP - 1: 0] ula_op;
    reg [0:9] signals_expected;
    reg [0:9] op_expected_signals [0 : (1 << `OP)];
    reg [`ULA_OP - 1: 0] ula_op_expected;
    reg [`ULA_OP - 1: 0] op_expected_ula_op[0 : (1 << `ULA_OP)];

  initial begin
    $dumpfile("control_unit.vcd");
    $dumpvars(0, control_unit_TB);
  end

  control_unit #(
    .OP(`OP)
  ) DUT (
    .op(op),
    .signals(signals),
    .ula_op(ula_op)
  );

  initial begin
    $display("\n### Test: control unit");
    $display("--------------------------------------------------------------------------------");
    $display("%10s %6s   %8s %7s %7s   %8s", "TIME", "OP", "SIGNALS", "S_EXP", "ULA_OP", "ULA_EXP ");
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H", $time, op, signals, signals_expected, ula_op, ula_op_expected);

    op_expected_signals[`BRZR] = 1 << `BR;
    op_expected_signals[`JI] = 1 << `J;
    op_expected_signals[`LD] = (1 << `RA) | (1 << `RE) | (1 << `DM);
    op_expected_signals[`ST] = 1 << `WE;
    op_expected_signals[`ADDI] = (1 << `RA) | (1 << `SE) | (1 << `RE);
    op_expected_signals[`PUSH] = (1 << `RA) | (1 << `RE) | (1 << `WE) | (1 << `DM) | (1 << `SP);
    op_expected_signals[`POP] = (1 << `RE) | (1 << `DM) | (1 << `SP) | (1 << `SPR);
    op_expected_signals[`MOV] = 1 << `RE;
    op_expected_signals[`NOT] = 1 << `RE;
    op_expected_signals[`AND] = 1 << `RE;
    op_expected_signals[`OR] = 1 << `RE;
    op_expected_signals[`XOR] = 1 << `RE;
    op_expected_signals[`ADD] = 1 << `RE;
    op_expected_signals[`SUB] = 1 << `RE;
    op_expected_signals[`SLR] = 1 << `RE;
    op_expected_signals[`SRR] = 1 << `RE;

    op_expected_ula_op[`NOT & ~(1 << `ULA_OP)] = `NOT;
    op_expected_ula_op[`AND & ~(1 << `ULA_OP)] = `AND;
    op_expected_ula_op[`OR & ~(1 << `ULA_OP)] = `OR;
    op_expected_ula_op[`XOR & ~(1 << `ULA_OP)] = `XOR;
    op_expected_ula_op[`ADD & ~(1 << `ULA_OP)] = `ADD;
    op_expected_ula_op[`SUB & ~(1 << `ULA_OP)] = `SUB;
    op_expected_ula_op[`SLR & ~(1 << `ULA_OP)] = `SLR;
    op_expected_ula_op[`SRR & ~(1 << `ULA_OP)] = `SRR;

    for (integer unsigned i = 0; i < (1 << `OP); i++) begin
      op = i;
      signals_expected = op_expected_signals[i];
      ula_op_expected = (i == `ADDI || i >= `NOT) ? op_expected_ula_op[i & ~(1 << `ULA_OP)] : 0;

      `ASSERT(signals, signals_expected);
      `ASSERT(ula_op, ula_op_expected);
    end
  end
endmodule
