
import bus_pkg::*;

module interconnect(bus_if master, bus_if s0, bus_if s1);
  
  always_comb begin
    s0.valid = 0;
    s1.valid = 0;
    s0.wr_en = master.wr_en;
    s1.wr_en = master.wr_en;
    s0.addr  = master.addr;
    s1.addr  = master.addr;
    s0.wdata = master.wdata;
    s1.wdata = master.wdata;

    if (master.valid) begin
      if (master.addr < 8'h40)
        s0.valid = 1;
      else
        s1.valid = 1;
    end
  end

  always_comb begin
    master.ready = 0;
    master.rdata = 0;
    master.resp  = RESP_OKAY;
    if (s0.ready) begin
      master.ready = s0.ready;
      master.rdata = s0.rdata;
      master.resp  = s0.resp;
    end else if (s1.ready) begin
      master.ready = s1.ready;
      master.rdata = s1.rdata;
      master.resp  = s1.resp;
    end
  end
  
endmodule
