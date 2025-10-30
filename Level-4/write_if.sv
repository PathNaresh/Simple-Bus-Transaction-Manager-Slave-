
interface write_if #(parameter ADDR_WIDTH=8, DATA_WIDTH=32) (input logic clk);
  
  logic              valid;        // master -> initiates write
  logic              ready;        // slave -> accepts / completes
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] data;
  logic [3:0]        id;           // transaction id
  logic [1:0]        resp;         // response
  
  // reset
  initial begin
    valid = 0; ready = 0; addr = 0; data = 0; id = 0; resp = 2'b00;
  end
  
endinterface
