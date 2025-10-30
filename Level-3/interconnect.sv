
module interconnect(bus_if master,
                    bus_if slave0,
                    bus_if slave1);

  always_comb begin
    // Default
    slave0.valid = 0;
    slave1.valid = 0;
    slave0.wr_en = master.wr_en;
    slave1.wr_en = master.wr_en;
    slave0.addr  = master.addr;
    slave1.addr  = master.addr;
    slave0.wdata = master.wdata;
    slave1.wdata = master.wdata;

    // Decode
    if (master.valid) begin
      if (master.addr < 8'h40)
        slave0.valid = 1;
      else
        slave1.valid = 1;
    end
  end

  // Multiplex responses back to manager
  always_comb begin
    master.ready = 0;
    master.rdata = 0;
    master.resp  = 2'b00;
    if (slave0.ready) begin
      master.ready = slave0.ready;
      master.rdata = slave0.rdata;
      master.resp  = slave0.resp;
    end else if (slave1.ready) begin
      master.ready = slave1.ready;
      master.rdata = slave1.rdata;
      master.resp  = slave1.resp;
    end
  end
  
endmodule
