
module slave(bus_if bus);
  
  logic [31:0] mem [0:255];
  int latency;

  always @(posedge bus.clk) begin
    bus.ready <= 0;
    bus.resp  <= 2'b00;
    if (bus.valid) begin
      latency = $urandom_range(1,3); // variable delay cycles
      repeat(latency) @(posedge bus.clk);

      if (bus.wr_en) begin
        for (int i=0; i<bus.burst_len; i++) begin
          mem[bus.addr + i] <= bus.wdata;
          bus.ready <= 1;
          @(posedge bus.clk);
          bus.ready <= 0;
        end
      end else begin
        for (int i=0; i<bus.burst_len; i++) begin
          bus.rdata <= mem[bus.addr + i];
          bus.ready <= 1;
          @(posedge bus.clk);
          bus.ready <= 0;
        end
      end
      bus.resp <= 2'b00; // OKAY
    end
  end
  
endmodule
