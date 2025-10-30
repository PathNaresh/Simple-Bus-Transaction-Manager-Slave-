
//-----------------------------------------------------------------------------
// Slave: separate write/read channels, independent latency, uses BASE_ADDR
//-----------------------------------------------------------------------------

module slave #(parameter BASE_ADDR=8'h00, RANGE=8'h3F) (
  write_if w_if,
  read_if  r_if
);
  
  logic [31:0] mem [0:255]; // small local mem
  int write_lat;
  int read_lat;

  // WRITE channel handling
  always @(posedge w_if.clk) begin
    w_if.ready <= 0;
    w_if.resp  <= 2'b00;
    if (w_if.valid && (w_if.addr >= BASE_ADDR) && (w_if.addr <= BASE_ADDR + RANGE)) begin
      write_lat = $urandom_range(1,4);
      repeat(write_lat) @(posedge w_if.clk);
      mem[w_if.addr - BASE_ADDR] <= w_if.data;
      w_if.resp <= 2'b00;
      w_if.ready <= 1;
      @(posedge w_if.clk);
      w_if.ready <= 0;
    end
  end

  // READ channel handling
  always @(posedge r_if.clk) begin
    r_if.ready <= 0;
    r_if.resp  <= 2'b00;
    if (r_if.valid && (r_if.addr >= BASE_ADDR) && (r_if.addr <= BASE_ADDR + RANGE)) begin
      read_lat = $urandom_range(1,4);
      repeat(read_lat) @(posedge r_if.clk);
      r_if.data <= mem[r_if.addr - BASE_ADDR];
      r_if.resp <= 2'b00;
      r_if.ready <= 1;
      @(posedge r_if.clk);
      r_if.ready <= 0;
    end
  end

endmodule
