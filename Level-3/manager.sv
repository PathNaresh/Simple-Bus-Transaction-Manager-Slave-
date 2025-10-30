
// The manager will now issue accesses to two different address regions:
// 0x00–0x3F → Slave0
// 0x40–0x7F → Slave1

module manager(bus_if bus);
  
  task automatic do_write(input [7:0] addr, input [31:0] data);
    bus.valid = 1;
    bus.wr_en = 1;
    bus.addr  = addr;
    bus.wdata = data;
    @(posedge bus.clk);
    wait(bus.ready);
    bus.valid = 0;
    $display("[%0t] Write: Addr=0x%0h Data=0x%0h Resp=%0b",
             $time, addr, data, bus.resp);
  endtask

  task automatic do_read(input [7:0] addr);
    bus.valid = 1;
    bus.wr_en = 0;
    bus.addr  = addr;
    @(posedge bus.clk);
    wait(bus.ready);
    $display("[%0t] Read: Addr=0x%0h Data=0x%0h Resp=%0b",
             $time, addr, bus.rdata, bus.resp);
    bus.valid = 0;
  endtask

  initial begin
    #20;
    do_write(8'h10, 32'hAAAA_BBBB);  // Slave0 region
    do_write(8'h50, 32'hCCCC_DDDD);  // Slave1 region
    #30;
    do_read(8'h10);
    do_read(8'h50);
    #50 $finish;
  end
  
endmodule
