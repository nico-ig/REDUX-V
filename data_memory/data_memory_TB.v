`include "utils.vh"

module data_memory_TB ();

  reg clk;
  reg write_enable;
  reg [`BITS-1:0] address;
  reg [`BITS-1:0] data_in;
  reg [`BITS-1:0] expected;
  wire [`BITS-1:0] data_out;

  initial begin
    $dumpfile("data_memory_TB.vcd");
    $dumpvars(0, data_memory_TB);
  end

  data_memory #(
      .MEMORY_BITS(`MEMORY_BITS),
      .MEMORY_SIZE(`MEMORY_SIZE)
  ) DUT (
      .clk(clk),
      .write_enable(write_enable),
      .address(address),
      .data_in(data_in),
      .data_out(data_out)
  );

  always #`HALF_CLK clk = !clk;

  initial begin
    $monitor("%10d    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H    0x%02H", $time, clk,
             write_enable, address, data_in, data_out, expected);

    $display("\n### Test: data memory");
    $display("--------------------------------------------------------------------------------");
    $display("%10s %7s %6s %8s %7s %8s %7s", "TIME", "CLK", "WE", "ADDR", "D_IN", "D_OUT",
             "EXPECTED");

    clk = 1'd0;
    write_enable = 1'd0;
    address = 8'd255;
    data_in = 8'd255;
  end

  always @(clk) begin
    if (clk == 1'd0) begin
      write_enable = !write_enable;
      if (write_enable == 1'd1) begin
        address = address + 8'd1;
        if (address == 8'd0) begin
          data_in = data_in + 8'd1;
          $display();
          $display("%10s %7s %6s %8s %7s %8s %7s", "TIME", "CLK", "WE", "ADDR", "D_IN", "D_OUT",
                   "EXPECTED");
        end
      end else begin
        expected = data_in;
        `ASSERT(data_out, expected);
        if (expected == 8'd255 && address == 8'd255) begin
          $display();
          $finish();
        end
      end
    end
  end
endmodule
