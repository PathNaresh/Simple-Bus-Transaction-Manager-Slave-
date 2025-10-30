
`timescale 1ns/1ps

module top_tb;
  
  // clock
  logic clk = 0;
  always #5 clk = ~clk; // 100MHz

  // virtual interfaces
  write_if  w_master_if(clk);
  read_if   r_master_if(clk);
  
  write_if  w_s0_if(clk);
  read_if   r_s0_if(clk);
  
  write_if  w_s1_if(clk);
  read_if   r_s1_if(clk);

  // instantiate DUT pieces
  manager #( .ADDR_WIDTH(8), .DATA_WIDTH(32) ) m0(
    .w_if(w_master_if),
    .r_if(r_master_if)
  );

  slave #(.BASE_ADDR(8'h00), .RANGE(8'h3F)) s0(
    .w_if(w_s0_if),
    .r_if(r_s0_if)
  );

  slave #(.BASE_ADDR(8'h40), .RANGE(8'h3F)) s1(
    .w_if(w_s1_if),
    .r_if(r_s1_if)
  );

  interconnect ic (
    .w_master(w_master_if),
    .r_master(r_master_if),
    .w_s0(w_s0_if),
    .r_s0(r_s0_if),
    .w_s1(w_s1_if),
    .r_s1(r_s1_if)
  );

  // mailboxes for monitors -> scoreboard
  mailbox mb_write = new();
  mailbox mb_read  = new();

  // create monitors & scoreboard (class-based)
  initial begin
    // wait a little for structural elaboration
    #1;
    write_monitor wmon = new(virtual write_if(w_master_if), mb_write);
    read_monitor  rmon = new(virtual read_if(r_master_if), mb_read);
    scoreboard    sb   = new(mb_write, mb_read);

    // spawn monitors/scoreboard tasks
    fork
      wmon.run();
      rmon.run();
      sb.run();
    join_none

    // run simulation for fixed time then finish
    #2000;
    $display("=== SIM END ===");
    $finish;
  end

endmodule
