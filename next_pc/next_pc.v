module next_pc #(
    parameter integer BITS = 8
) (
    input wire brzr_sel,
    input wire jmp_sel,
    input wire [BITS-1:0] pc_brzr,
    input wire [BITS-1:0] pc_jmp,
    input wire [BITS-1:0] pc,
    output reg [BITS-1:0] next_pc
);
  initial next_pc = 0;

  always @* begin
    case ({
      brzr_sel, jmp_sel
    })
      {1'b1, 1'b0} : next_pc = pc_brzr;
      {1'b0, 1'b1} : next_pc = pc_jmp;
      default: next_pc = pc;
    endcase
  end
endmodule
