
module manager(bus_if bus);
  
  task automatic do_write(input [7:0] addr, input [31:0] data[], input int beats);
    int i;
    bus.valid = 1;
    bus.wr_en = 1;
    bus.addr  = addr;
    bus.burst_len = beats;
    for (i = 0; i < beats; i++) begin
      bus.wdata = data[i];
      @(posedge bus.clk);
      wait (bus.ready);
    end
    bus.valid = 0;
    $display("[%0t] Write burst of %0d beats to 0x%0h done (resp=%0b)",
             $time, beats, addr, bus.resp);
  endtask

  task automatic do_read(input [7:0] addr, input int beats);
    int i;
    bus.valid = 1;
    bus.wr_en = 0;
    bus.addr  = addr;
    bus.burst_len = beats;
    for (i = 0; i < beats; i++) begin
      @(posedge bus.clk);
      wait (bus.ready);
      $display("[%0t] Read[%0d] from 0x%0h = 0x%0h (resp=%0b)",
               $time, i, addr+i, bus.rdata, bus.resp);
    end
    bus.valid = 0;
  endtask

  // Drive some sample transactions
  initial begin
    #20;
    logic [31:0] wdata_burst[4] = '{32'hDEAD_BEEF, 32'hBEEF_CAFE, 32'h1234_5678, 32'hA5A5_5A5A};
    do_write(8'h20, wdata_burst, 4);
    #50;
    do_read(8'h20, 4);
    #50 $finish;
  end
  
endmodule
