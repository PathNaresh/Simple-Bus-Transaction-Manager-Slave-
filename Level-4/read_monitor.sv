
class read_monitor;
  
  virtual read_if vif;
  mailbox mb;
  function new(virtual read_if vif_, mailbox mb_);
    vif = vif_;
    mb  = mb_;
  endfunction

  task run();
    read_rec_t rec;
    forever begin
      @(posedge vif.clk);
      if (vif.ready && vif.valid) begin
        rec.addr = vif.addr;
        rec.data = vif.data;
        rec.id   = vif.id;
        rec.resp = vif.resp;
        rec.time_ns = $time;
        mb.put(rec);
        $display("[%0t] RMON: read  id=%0d addr=0x%0h data=0x%0h", $time, rec.id, rec.addr, rec.data);
      end
    end
  endtask
  
endclass
