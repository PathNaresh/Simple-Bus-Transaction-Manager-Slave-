
package bus_pkg;
  
  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 32;

  typedef enum logic [1:0] {
    RESP_OKAY = 2'b00,
    RESP_ERR  = 2'b11
  } resp_t;

  typedef struct packed {
    logic wr_en;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;
    resp_t resp;
  } bus_txn_t;
  
endpackage
