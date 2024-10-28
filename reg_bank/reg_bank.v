module reg_bank #(
    parameter integer BITS = 8,
    parameter integer REG_SIZE = 4
) (
    input wire clk,
    input wire write_enable,
    input wire [0 : $clog2(REG_SIZE) - 1] address_a,
    input wire [0 : $clog2(REG_SIZE) - 1] address_b,
    input wire [0 : $clog2(REG_SIZE) - 1] write_address,
    input wire [BITS-1:0] write_data,
    output reg [BITS-1:0] data_a,
    output reg [BITS-1:0] data_b
);
  reg [BITS-1:0] reg_bank[0:REG_SIZE - 1];

  always @* begin
    data_a = reg_bank[address_a];
    data_b = reg_bank[address_b];
  end

  always @(posedge(clk)) begin
    if (write_enable) reg_bank[write_address] = write_data;
  end

  endmodule
