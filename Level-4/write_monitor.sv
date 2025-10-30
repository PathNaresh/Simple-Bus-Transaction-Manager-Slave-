
//-----------------------------------------------------------------------------
// Monitors (class-based) - observe master interface and push records to mailbox
//-----------------------------------------------------------------------------

typedef struct packed {
  logic [7:0]  addr;
  logic [31:0] data;
  logic [3:0]  id;
  logic [1:0]  resp;
  time         time_ns;
} write_rec_t;

typedef struct packed {
  logic [7:0]  addr;
  logic [31:0] data;
  logic [3:0]  id;
  logic [1:0]  resp;
  time         time_ns;
} read_rec_t;

class write_monitor;
  
  virtual write_if vif;
  mailbox mb;
  function new(virtual write_if vif_, mailbox mb_);
    vif = vif_;
    mb  = mb_;
  endfunction

  task run();
    write_rec_t rec;
    forever begin
      @(posedge vif.clk);
      if (vif.ready && vif.valid) begin
        rec.addr = vif.addr;
        rec.data = vif.data;
        rec.id   = vif.id;
        rec.resp = vif.resp;
        rec.time_ns = $time;
        mb.put(rec);
        $display("[%0t] WMON: wrote id=%0d addr=0x%0h data=0x%0h", $time, rec.id, rec.addr, rec.data);
      end
    end
  endtask
  
endclass
