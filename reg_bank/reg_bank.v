module reg_bank #(
    parameter integer BITS = 8,
    parameter integer REG_BITS = 8,
    parameter integer REG_SIZE = 2
) (
    input wire clk,
    input wire write_enable,
    input wire [REG_BITS-1:0] address_a,
    input wire [REG_BITS-1:0] address_b,
    input wire [REG_BITS-1:0] write_address,
    input wire [BITS-1:0] write_data,
    output reg [BITS-1:0] data_a,
    output reg [BITS-1:0] data_b
);

  reg [BITS-1:0] reg_bank[0:REG_SIZE-1];

  always @(posedge (clk)) begin
    if (write_enable == 1'd1) reg_bank[write_address] <= write_data;
    else begin
      data_a = reg_bank[address_a];
      data_b = reg_bank[address_b];
    end
  end
endmodule
