
import bus_pkg::*;

module manager(bus_if bus);
  
  task automatic write(input [7:0] addr, input [31:0] data);
    bus.valid = 1;
    bus.wr_en = 1;
    bus.addr  = addr;
    bus.wdata = data;
    @(posedge bus.clk);
    wait(bus.ready);
    bus.valid = 0;
    $display("[%0t] MANAGER: Write 0x%0h -> Addr 0x%0h", $time, data, addr);
  endtask

  task automatic read(input [7:0] addr);
    bus.valid = 1;
    bus.wr_en = 0;
    bus.addr  = addr;
    @(posedge bus.clk);
    wait(bus.ready);
    $display("[%0t] MANAGER: Read 0x%0h from Addr 0x%0h", $time, bus.rdata, addr);
    bus.valid = 0;
  endtask

  initial begin
    #20;
    write(8'h10, 32'hAAAA_BBBB);
    write(8'h50, 32'hCCCC_DDDD);
    #30;
    read(8'h10);
    read(8'h50);
    #50 $finish;
  end
  
endmodule
