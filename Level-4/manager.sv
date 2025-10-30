
//-----------------------------------------------------------------------------
// Manager: issues writes and reads with IDs (multi-outstanding)
//-----------------------------------------------------------------------------

module manager #(parameter ADDR_WIDTH=8, DATA_WIDTH=32) (
  write_if  w_if,
  read_if   r_if
);
  // simple ID allocator
  logic [3:0] next_id = 0;
  function automatic [3:0] alloc_id();
    alloc_id = next_id;
    next_id = next_id + 1;
  endfunction

  // Issue write
  task automatic write_trans(input logic [ADDR_WIDTH-1:0] addr, input logic [DATA_WIDTH-1:0] data);
    logic [3:0] tid = alloc_id();
    w_if.addr  = addr;
    w_if.data  = data;
    w_if.id    = tid;
    w_if.valid = 1;
    @(posedge w_if.clk);
    // wait for completion from slave (ready asserted)
    wait (w_if.ready == 1);
    $display("[%0t] MGR WRITE DONE id=%0d addr=0x%0h data=0x%0h resp=%0b", $time, tid, addr, data, w_if.resp);
    // deassert
    w_if.valid = 0;
    @(posedge w_if.clk);
  endtask

  // Issue read
  task automatic read_trans(input logic [ADDR_WIDTH-1:0] addr);
    logic [3:0] tid = alloc_id();
    r_if.addr  = addr;
    r_if.id    = tid;
    r_if.valid = 1;
    @(posedge r_if.clk);
    wait (r_if.ready == 1);
    $display("[%0t] MGR READ DONE id=%0d addr=0x%0h data=0x%0h resp=%0b", $time, tid, addr, r_if.data, r_if.resp);
    r_if.valid = 0;
    @(posedge r_if.clk);
  endtask

  // create some traffic: mixed, with some outstanding capability
  initial begin
    #20;
    // write to s0
    fork
      begin write_trans(8'h10, 32'h1111_1111); end
      begin write_trans(8'h12, 32'h2222_2222); end
      begin write_trans(8'h50, 32'hAAAA_AAAA); end
    join_none

    #100;
    // reads (some may overlap)
    fork
      begin read_trans(8'h10); end
      begin read_trans(8'h12); end
      begin read_trans(8'h50); end
      begin read_trans(8'h51); end
    join_none

    #400;
    // another burst of traffic
    write_trans(8'h11, 32'h3333_3333);
    read_trans(8'h11);
  end
  
endmodule
