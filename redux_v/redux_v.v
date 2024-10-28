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

wire [`SPR : 0] signals_cu;
wire [BITS - 1 : 0] sp;
wire [BITS - 1 : 0] pc;
wire [BITS - 1 : 0] next_pc;
wire [MEMORY_BITS - 1 : 0] instruction;
wire [$clog2(REG_SIZE) - 1 : 0] address_a_reg;
wire [$clog2(REG_SIZE) - 1 : 0] address_b_reg;
wire [$clog2(REG_SIZE) - 1 : 0] write_address_reg;
wire [BITS - 1 : 0] write_data_reg;
wire [BITS - 1 : 0] data_a_reg;
wire [BITS - 1 : 0] data_b_reg;
wire [ULA_OP - 1 : 0] ula_op;
wire [BITS - 1 : 0] b_in_ula;
wire [BITS - 1 : 0] result_out_ula;
wire [BITS - 1 : 0] address_dm;
wire [BITS - 1 : 0] data_in_dm;
wire [BITS - 1 : 0] data_out_dm;
wire [BITS - 1 : 0] sign_ext = start_up ? 1'd0 : {{4{instruction[3]}}, instruction[3:0]};
wire [`SPR : 0] signals = start_up ? signals_s : signals_cu;
wire [BITS - 1 : 0] mux_rd = start_up ? 1'd0 : signals[`RD] == 1'd1 ? data_b_reg : mux_dm;
wire [BITS - 1 : 0] mux_dm = start_up ? 1'd0 : signals[`DM] == 1'd1 ? data_out_dm : result_out_ula;

wire [`SPR : 0] signals_s;
reg finish = 1'd0;
reg start_up = 1'd1;
reg [0 : BITS] address_s = {(BITS+1'd1){1'd1}};

assign address_b_reg = start_up ? {BITS{1'b0}} : instruction[1:0];
assign address_a_reg = start_up || !signals[`RA] ? {$clog2(REG_SIZE){1'b0}} : instruction[3:2];
assign write_address_reg = start_up ? address_s & {$clog2(REG_SIZE){1'd1}}: signals[`SPR] ? address_b_reg : address_a_reg;
assign write_data_reg = start_up ? {BITS{1'b0}} : signals[`SPR] ? sp : mux_rd;
assign b_in_ula = start_up ? 0 : signals[`SE] ? sign_ext : data_b_reg;
assign address_dm = start_up ? address_s & {BITS{1'd1}} : signals[`SP] == 1 ? sp : data_b_reg;

next_pc #(.BITS(BITS)) NEXT_PC (.brzr_sel(signals[`BR] && !data_a_reg), .jmp_sel(signals[`J]), .pc_brzr(data_b_reg), .pc_jmp(pc + sign_ext), .pc(start_up ? {BITS{1'b0}} : pc + 1'd1), .next_pc(next_pc));
pc #(.BITS(BITS)) PC (.clk(clk), .next_pc(next_pc), .pc(pc));
instruction_memory #(.MEMORY_BITS(MEMORY_BITS)) IM (.clk(clk), .pc(pc), .instruction(instruction));
reg_bank #(.BITS(BITS), .REG_SIZE(REG_SIZE)) RB (.clk(clk), .write_enable(signals[`RE]), .address_a(address_a_reg), .address_b(address_b_reg), .write_address(write_address_reg), .write_data(write_data_reg), .data_a(data_a_reg), .data_b(data_b_reg));
ula #(.ULA_OP(ULA_OP), .BITS(BITS)) ULA (.ula_op_in(ula_op), .a_in(data_a_reg), .b_in(b_in_ula), .result_out(result_out_ula));
data_memory #(.MEMORY_BITS(MEMORY_BITS), .MEMORY_SIZE(MEMORY_SIZE)) DM (.clk(clk), .write_enable(signals[`WE]), .address(address_dm), .data_in(data_a_reg), .data_out(data_out_dm));
sp #(.BITS(BITS)) SP (.clk(clk), .op(instruction[4]), .write_enable(signals[`SP]), .sp(sp));
control_unit #(.OP(OP)) CU (.op(instruction[7:4]), .signals(signals_cu), .ula_op(ula_op));

assign signals_s = finish ? 1'd0 : address_s > REG_SIZE * 2 ? 1'd1 << `WE : (1'd1 << `WE) | (1'd1 << `RE);

always @(posedge(clk)) begin
    address_s = address_s === MEMORY_SIZE ? {BITS+1'd1{1'd0}} : address_s + 1'd1;
    finish = finish ? 1'd1 : address_s === MEMORY_SIZE;
    start_up = !start_up ? 1'd0 : finish ? address_s !== 3'd7 : 1'd1;
end

endmodule
