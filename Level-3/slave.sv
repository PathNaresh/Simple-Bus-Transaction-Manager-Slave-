
module slave #(parameter BASE_ADDR=8'h00, parameter RANGE=8'h3F)(bus_if bus);
  
  logic [31:0] mem [0:63];
  int delay;

  always @(posedge bus.clk) begin
    bus.ready <= 0;
    bus.resp  <= 2'b00;

    // Only respond if address falls in range
    if (bus.valid && bus.addr >= BASE_ADDR && bus.addr <= (BASE_ADDR + RANGE)) begin
      delay = $urandom_range(1, 3); // 1–3 cycle delay
      repeat (delay) @(posedge bus.clk);

      if (bus.wr_en) begin
        mem[bus.addr - BASE_ADDR] <= bus.wdata;
      end else begin
        bus.rdata <= mem[bus.addr - BASE_ADDR];
      end

      bus.resp  <= 2'b00; // OKAY
      bus.ready <= 1;
      @(posedge bus.clk);
      bus.ready <= 0;
    end
  end
  
endmodule
