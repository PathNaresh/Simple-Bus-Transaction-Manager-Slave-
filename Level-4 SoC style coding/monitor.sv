
import bus_pkg::*;

module monitor(bus_if bus);
  
  always @(posedge bus.clk)
    if (bus.valid && bus.ready)
      $display("[%0t] MONITOR: %s Addr=0x%0h Data=0x%0h Resp=%0b",
        $time,
        bus.wr_en ? "WRITE" : "READ",
        bus.addr,
        bus.wr_en ? bus.wdata : bus.rdata,
        bus.resp);
  
endmodule
