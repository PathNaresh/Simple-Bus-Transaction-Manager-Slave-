
import bus_pkg::*;

module slave #(parameter BASE_ADDR=8'h00, RANGE=8'h3F)(
  bus_if bus
);
  
  logic [31:0] mem [0:63];

  always @(posedge bus.clk) begin
    bus.ready <= 0;
    bus.resp  <= RESP_OKAY;

    if (bus.valid && bus.addr >= BASE_ADDR && bus.addr <= (BASE_ADDR + RANGE)) begin
      repeat ($urandom_range(1,3)) @(posedge bus.clk);
      if (bus.wr_en) begin
        mem[bus.addr - BASE_ADDR] <= bus.wdata;
      end else begin
        bus.rdata <= mem[bus.addr - BASE_ADDR];
      end
      bus.ready <= 1;
      @(posedge bus.clk);
      bus.ready <= 0;
    end
  end
  
endmodule
