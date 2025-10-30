
`timescale 1ns/1ps

module top_tb;
  
  logic clk = 0;
  always #5 clk = ~clk;

  // Create interfaces
  bus_if master_if(clk);
  bus_if s0_if(clk);
  bus_if s1_if(clk);

  // Instantiate modules
  manager      m0(master_if);
  slave #(.BASE_ADDR(8'h00)) s0(s0_if);
  slave #(.BASE_ADDR(8'h40)) s1(s1_if);
  interconnect ic(master_if, s0_if, s1_if);
  
endmodule
