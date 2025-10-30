
module manager(bus_if bus);

  initial begin
    // WRITE transaction
    bus.valid = 1;
    bus.wr_en = 1;
    bus.addr  = 8'h10;
    bus.wdata = 32'hABCD_1234;
    @(posedge bus.clk);
    wait (bus.ready); // wait for slave to respond

    // READ transaction
    bus.valid = 1;
    bus.wr_en = 0;
    bus.addr  = 8'h10;
    @(posedge bus.clk);
    wait (bus.ready);
    $display("Read Data = 0x%0h", bus.rdata);

    bus.valid = 0;
  end
  
endmodule
