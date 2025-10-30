
`timescale 1ns/1ps

module top_tb;
  
  logic clk = 0;
  always #5 clk = ~clk;  // 100MHz

  bus_if bus(clk);
  manager m0(bus);
  slave   s0(bus);
  
endmodule
