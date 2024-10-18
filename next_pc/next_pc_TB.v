`include "utils.vh"

module next_pc_TB ();
  reg brzr_sel;
  reg jmp_sel;
  reg [`BITS-1:0] pc_brzr;
  reg [`BITS-1:0] pc_jmp;
  reg [`BITS-1:0] pc;
  wire [`BITS-1:0] next_pc;
  reg [`BITS-1:0] expected;

  initial begin
    $dumpfile("next_pc.vcd");
    $dumpvars(0, next_pc_TB);
  end

  next_pc #(
      .BITS(`BITS)
  ) DUT (
      .brzr_sel(brzr_sel),
      .jmp_sel(jmp_sel),
      .pc_brzr(pc_brzr),
      .pc_jmp(pc_jmp),
      .pc(pc),
      .next_pc(next_pc)
  );

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H", $time,
             pc, pc_brzr, brzr_sel, pc_jmp, jmp_sel, next_pc, expected);

    $display("\n### Test: next pc");
    $display("--------------------------------------------------------------------------------");

    for (reg [8:0] pc_ = 9'd0; pc_ < 9'd256; pc_ = pc_ + 1'd1) begin
      pc = pc_;
      for (reg [8:0] pc_brzr_ = 9'd0; pc_brzr_ < 9'd256; pc_brzr_ = pc_brzr_ + 1'd1) begin
        pc_brzr = pc_brzr_;
        $display();
        $display("%10s %6s   %7s %7s %6s %7s %7s %8s", "TIME", "PC", "PC_BRZR", "BRZR_SEL",
                 "PC_JMP", "JMP_SEL", "NEXT_PC", "EXPECTED");
        for (reg [8:0] pc_jmp_ = 9'd0; pc_jmp_ < 9'd256; pc_jmp_ = pc_jmp_ + 1'd1) begin
          pc_jmp   = pc_jmp_;

          brzr_sel = 1'd0;
          jmp_sel  = 1'd0;
          expected = pc;
          `ASSERT(next_pc, expected);

          jmp_sel  = 1'd1;
          expected = pc_jmp;
          `ASSERT(next_pc, expected);

          brzr_sel = 1'd1;
          expected = pc;
          `ASSERT(next_pc, expected);

          jmp_sel  = 1'd0;
          expected = pc_brzr;
          `ASSERT(next_pc, expected);
        end
      end
    end
    $display();
    $finish();
  end
endmodule
