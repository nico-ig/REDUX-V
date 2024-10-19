module control_unit #(
    parameter integer OP = 4
) (
    input reg [OP - 1 : 0] op,
    output reg signals[0:9],
    output reg [ALU_OP - 1: 0] alu_op
);

  always @* begin
    //zerar todos de algum jeito antes
    case (op)
      BRZR: signals[BR] = 1'd1;
      JI: signals[J] = 1'd1;
      LD: begin
        signals[RA] = 1'd1;
        signals[RE] = 1'd1;
        signals[DM] = 1'd1;
      end
      ST: signals[WE] = 1'd1;
      ADDI: begin
        signals[RA] = 1'd1;
        signals[SE] = 1'd1;
        signals[RE] = 1'd1;
      end
      PUSH: ;
      POP: ;
      MOV: ;
      NOT: ;
      AND: ;
      OR: ;
      XOR: ;
      ADD: ;
      SUB: ;
      SLR: ;
      SRR: ;
      default: ;
    endcase
  end
endmodule
