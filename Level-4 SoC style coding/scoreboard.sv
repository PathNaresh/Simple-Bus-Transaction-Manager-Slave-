
import bus_pkg::*;

module scoreboard(bus_if bus);
  
  logic [31:0] expected [0:255];

  always @(posedge bus.clk)
    if (bus.valid && bus.ready) begin
      if (bus.wr_en)
        expected[bus.addr] = bus.wdata;
      else if (expected.exists(bus.addr) && bus.rdata !== expected[bus.addr])
        $display("[%0t] ❌ Mismatch at Addr=0x%0h Expected=0x%0h Got=0x%0h",
          $time, bus.addr, expected[bus.addr], bus.rdata);
    end
  
endmodule
