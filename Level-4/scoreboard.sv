
//-----------------------------------------------------------------------------
// Scoreboard: consumes write/read records and verifies correctness
//-----------------------------------------------------------------------------

class scoreboard;
  mailbox mb_w, mb_r;
  // golden memory (global across slaves)
  logic [31:0] golden_mem [0:255];
  function new(mailbox mbw, mailbox mbr);
    mb_w = mbw; mb_r = mbr;
    // init mem to unknown pattern to detect reads before writes
    foreach (golden_mem[i]) golden_mem[i] = 32'hDEAD_BEEF ^ i;
  endfunction

  task run();
    write_rec_t wrec;
    read_rec_t  rrec;
    fork
      begin // write consumer
        forever begin
          mb_w.get(wrec);
          golden_mem[wrec.addr] = wrec.data;
          $display("[%0t] SB: accepted write id=%0d addr=0x%0h data=0x%0h", $time, wrec.id, wrec.addr, wrec.data);
        end
      end
      begin // read consumer
        forever begin
          mb_r.get(rrec);
          if (golden_mem[rrec.addr] !== rrec.data) begin
            $display("ERROR [%0t] SB mismatch id=%0d addr=0x%0h expected=0x%0h got=0x%0h",
                     $time, rrec.id, rrec.addr, golden_mem[rrec.addr], rrec.data);
          end else begin
            $display("PASS  [%0t] SB match   id=%0d addr=0x%0h data=0x%0h",
                     $time, rrec.id, rrec.addr, rrec.data);
          end
        end
      end
    join_none
  endtask
  
endclass
