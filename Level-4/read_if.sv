
interface read_if #(parameter ADDR_WIDTH=8, DATA_WIDTH=32) (input logic clk);
  
  logic              valid;        // master -> initiates read
  logic              ready;        // slave -> completes (response available)
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] data;     // read data from slave to master
  logic [3:0]        id;           // transaction id
  logic [1:0]        resp;         // response
  
  initial begin
    valid = 0; ready = 0; addr = 0; data = 0; id = 0; resp = 2'b00;
  end
  
endinterface
