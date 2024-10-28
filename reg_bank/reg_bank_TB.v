`include "utils.vh"

module reg_bank_TB ();
  reg clk;
  reg write_enable;
  reg [`REG_BITS-1:0] address_a;
  reg [`REG_BITS-1:0] address_b;
  reg [`REG_BITS-1:0] write_address;
  reg [`BITS-1:0] write_data;
  wire [`BITS-1:0] data_a;
  wire [`BITS-1:0] data_b;
  reg [`BITS-1:0] expected_a;
  reg [`BITS-1:0] expected_b;

  initial begin
    $dumpfile("reg_bank.vcd");
    $dumpvars(0, reg_bank_TB);
  end

  reg_bank #(
      .BITS(`BITS),
      .REG_SIZE(`REG_SIZE)
  ) DUT (
      .clk(clk),
      .write_enable(write_enable),
      .address_a(address_a),
      .address_b(address_b),
      .write_address(write_address),
      .write_data(write_data),
      .data_a(data_a),
      .data_b(data_b)
  );

  always #`HALF_CLK clk = !clk;

  initial begin
    $monitor(
        "%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H     0x%02H     0x%02H    0x%02H    0x%02H",
        $time, clk, write_enable, write_address, write_data, address_a, data_a, expected_a,
        address_b, data_b, expected_b);

    $display("\n### Test: reg bank");
    $display("-------------------------------------------------------------------------------------------------");
    $display("%10s %7s %6s  %8s %7s %7s %7s %8s %5s %7s %8s", "TIME", "CLK", "WE", "W_ADDR",
             "W_DATA", "ADDR_A", "DATA_A", "EXPECTED_A", "ADDR_B", "DATA_B", "EXPECTED_B");
    clk = 1'd0;
    write_enable = 1'b0;
    write_data = 8'd0;
    write_address = 8'd0;
    address_a = 8'd0;
    address_b = 8'd255;
  end

  always @(clk) begin
    if (clk == 0) begin
      if (write_enable == 1'd1) begin
        write_address = write_address + 1'd1;
        address_a = write_address - 1'd1;
        address_b = address_a - 1'd1;
        if (address_b == 2'b00) expected_b = expected_a;
        if (write_address == 8'd0) write_data = write_data + 8'd1;
      end else begin
        expected_a = write_data;
      end
      write_enable = !write_enable;
    end else begin
      if (write_enable == 1'd0) begin
        `ASSERT(expected_a, data_a);
        `ASSERT(expected_b, data_b);
        if (expected_b == 8'd255 && address_b == 2'd3) begin
          $display();
          $finish;
        end
      end
    end
  end
endmodule
