
//-----------------------------------------------------------------------------
// Interconnect: routes write/read channels to appropriate slave interfaces
//-----------------------------------------------------------------------------

module interconnect(
  write_if w_master, read_if r_master,
  write_if w_s0,     read_if r_s0,
  write_if w_s1,     read_if r_s1
);
  
  // route master -> slaves (write)
  always_comb begin
    // defaults
    w_s0.valid = 0; w_s1.valid = 0;
    w_s0.addr  = w_master.addr; w_s1.addr = w_master.addr;
    w_s0.data  = w_master.data; w_s1.data = w_master.data;
    w_s0.id    = w_master.id;   w_s1.id   = w_master.id;
    w_s0.resp  = 2'b00;         w_s1.resp = 2'b00;
    // decode
    if (w_master.valid) begin
      if (w_master.addr < 8'h40) begin
        w_s0.valid = 1;
      end else begin
        w_s1.valid = 1;
      end
    end
  end

  // route master -> slaves (read)
  always_comb begin
    r_s0.valid = 0; r_s1.valid = 0;
    r_s0.addr  = r_master.addr; r_s1.addr = r_master.addr;
    r_s0.id    = r_master.id;   r_s1.id    = r_master.id;
    r_s0.resp  = 2'b00;         r_s1.resp  = 2'b00;
    if (r_master.valid) begin
      if (r_master.addr < 8'h40) begin
        r_s0.valid = 1;
      end else begin
        r_s1.valid = 1;
      end
    end
  end

  // multiplex slave responses back to master for write channel
  always_comb begin
    w_master.ready = 0;
    w_master.resp  = 2'b00;
    if (w_s0.ready) begin
      w_master.ready = w_s0.ready;
      w_master.resp  = w_s0.resp;
    end else if (w_s1.ready) begin
      w_master.ready = w_s1.ready;
      w_master.resp  = w_s1.resp;
    end
  end

  // multiplex slave responses back to master for read channel
  always_comb begin
    r_master.ready = 0;
    r_master.data  = '0;
    r_master.resp  = 2'b00;
    if (r_s0.ready) begin
      r_master.ready = r_s0.ready;
      r_master.data  = r_s0.data;
      r_master.resp  = r_s0.resp;
    end else if (r_s1.ready) begin
      r_master.ready = r_s1.ready;
      r_master.data  = r_s1.data;
      r_master.resp  = r_s1.resp;
    end
  end

endmodule
