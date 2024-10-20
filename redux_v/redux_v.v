`include "utils.vh"

module redux_v #(
  parameter integer BITS = 8,
  parameter integer OP = 4,
  parameter integer ULA_OP = 3,
  parameter integer REG_BITS = 2,
  parameter integer REG_SIZE = 4,
  parameter integer MEMORY_BITS = 8,
  parameter integer MEMORY_SIZE = 256
) (
  input wire clk
);

wire [BITS - 1 : 0] pc;
wire [BITS - 1 : 0] next_pc;

next_pc #(.BITS(`BITS)) NEXT_PC (.brzr_sel(signals[`BR]), .jmp_sel(signals[`J]), .pc_brzr(data_b_reg), .pc_jmp(sign_ext), .pc(pc), .next_pc(next_pc));
pc #(.BITS(BITS)) PC (.clk(clk), .next_pc(next_pc), .pc(pc));

wire [MEMORY_BITS - 1 : 0] instruction;
instruction_memory #(.MEMORY_BITS(MEMORY_BITS)) IM (.clk(clk), .pc(pc), .instruction(instruction));

wire write_enable_reg;
wire [REG_BITS - 1 : 0] address_a_reg;
wire [REG_BITS - 1 : 0] address_b_reg;
wire [REG_BITS - 1 : 0] write_address_reg;
wire [BITS - 1 : 0] write_data_reg;
wire [BITS - 1 : 0] data_a_reg;
wire [BITS - 1 : 0] data_b_reg;

reg_bank #(.BITS(BITS), .REG_BITS(REG_BITS), .REG_SIZE(REG_SIZE)) RB (.clk(clk), .write_enable(write_enable_reg), .address_a(address_a_reg), .address_b(address_b_reg), .write_address(write_address_reg), .write_data(write_data_reg), .data_a(data_a_reg), .data_b(data_b_reg));

wire [ULA_OP - 1 : 0] ula_op;
wire [BITS - 1 : 0] a_in_ula;
wire [BITS - 1 : 0] b_in_ula;
wire [BITS - 1 : 0] result_out_ula;

ula #(.ULA_OP(ULA_OP), .BITS(BITS)) ULA (.ula_op_in(ula_op), .a_in(data_a_reg), .b_in(b_in_ula), .result_out(result_out_ula));

wire write_enable_dm;
wire [BITS - 1 : 0] address_dm;
wire [BITS - 1 : 0] data_in_dm;
wire [BITS - 1 : 0] data_out_dm;

data_memory #(.MEMORY_BITS(MEMORY_BITS), .MEMORY_SIZE(MEMORY_SIZE)) DM (.clk(clk), .write_enable(write_enable_dm), .address(address_dm), .data_in(data_a_reg), .data_out(data_out_dm));

wire write_enable_sp;
wire [BITS - 1 : 0] sp;

sp #(.BITS(BITS)) SP (.clk(clk), .op(instruction[0]), .write_enable(write_enable_sp), .sp(sp));

wire [9 : 0] signals;
control_unit #(.OP(OP)) CU (.op(instruction[7:4]), .signals(signals), .ula_op(ula_op));

assign address_b_reg = instruction[1:0];
assign address_a_reg = signals[`RA] == 1 ? instruction[3:2] : 0;
assign write_address = signals[`SPR] == 1 ? address_b_reg : address_a_reg;

wire mux_rd = signals[`RD] == 1 ? data_b_reg : mux_dm;
assign write_data_reg = signals[`SPR] == 1 ? sp : mux_rd;

wire [`BITS - 1 : 0] sign_ext = {{4{instruction[3]}}, instruction[3:0]};
assign b_in_ula = signals[`SE] == 1 ? sign_ext : data_b_reg;

wire mux_dm = signals[`DM] == 1 ? data_out_dm : result_out_ula;

assign address_dm = signals[`SP] == 1 ? sp : data_b_reg;
endmodule
