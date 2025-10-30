
module slave(bus_if bus);
  
  logic [31:0] mem [0:255];

  always @(posedge bus.clk) begin
    bus.ready <= 0;
    if (bus.valid) begin
      if (bus.wr_en) begin
        mem[bus.addr] <= bus.wdata;
      end else begin
        bus.rdata <= mem[bus.addr];
      end
      bus.ready <= 1; // respond after one cycle
    end
  end
  
endmodule
