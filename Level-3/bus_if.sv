
interface bus_if #(parameter ADDR_WIDTH=8, DATA_WIDTH=32)(input logic clk);
  
  logic                 valid;
  logic                 ready;
  logic                 wr_en;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  logic [1:0]            resp;
  
endinterface
