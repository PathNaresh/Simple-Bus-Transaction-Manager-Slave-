
interface bus_if(input logic clk);
  
  logic        valid;     // Manager drives when it has a transaction
  logic        wr_en;     // 1=write, 0=read
  logic [7:0]  addr;      // Address
  logic [31:0] wdata;     // Write data (from manager)
  logic [31:0] rdata;     // Read data (from slave)
  logic        ready;     // Slave asserts when done
  
endinterface
