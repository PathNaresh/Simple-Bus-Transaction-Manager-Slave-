
interface bus_if #(parameter ADDR_WIDTH=8, DATA_WIDTH=32) (input logic clk);
  
  logic                 valid;     // Manager initiates transaction
  logic                 ready;     // Slave ready to accept
  logic                 wr_en;     // 1=write, 0=read
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  logic [1:0]            resp;     // 00=OKAY, 01=SLVERR, etc.
  logic [3:0]            burst_len; // number of beats in burst
  
endinterface
