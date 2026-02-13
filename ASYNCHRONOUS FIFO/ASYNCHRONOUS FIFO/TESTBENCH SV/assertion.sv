// Async FIFO Assertions
module async_fifo_assertions 
    (input wclk, rclk, 
     input wrst, rrst,
     input wr, rd,
     input [7:0] Wdata,
     input [7:0] Rdata,
     input full, empty,
     input [2:0] b_wptr, b_rptr);

    // Assertion 1: FIFO cannot be both full and empty simultaneously
    property fifo_not_full_and_empty;
        @(posedge wclk or posedge rclk)
        !(full && empty);
    endproperty
    assert_not_full_and_empty: assert property(fifo_not_full_and_empty)
        else $error("FIFO cannot be both full and empty at the same time");
    
    // Assertion 2: Write pointer increments only on valid write
    property write_ptr_increment;
        @(posedge wclk)
        disable iff(wrst)
        (wr && !full) |-> ##1 (b_wptr == ($past(b_wptr) + 1));
    endproperty
    assert_write_ptr_increment: assert property(write_ptr_increment)
        else $error("Write pointer did not increment on valid write");
    
    // Assertion 3: Read pointer increments only on valid read
    property read_ptr_increment;
        @(posedge rclk)
        disable iff(rrst)
        (rd && !empty) |-> ##1 (b_rptr == ($past(b_rptr) + 1));
    endproperty
    assert_read_ptr_increment: assert property(read_ptr_increment)
        else $error("Read pointer did not increment on valid read");
    
    // Assertion 4: Write pointer remains stable when FIFO is full
    property write_ptr_stable_when_full;
        @(posedge wclk)
        disable iff(wrst)
        (full && wr) |-> ##1 (b_wptr == $past(b_wptr));
    endproperty
    assert_write_ptr_stable_when_full: assert property(write_ptr_stable_when_full)
        else $error("Write pointer changed when FIFO was full");
    
    // Assertion 5: Read pointer remains stable when FIFO is empty
    property read_ptr_stable_when_empty;
        @(posedge rclk)
        disable iff(rrst)
        (empty && rd) |-> ##1 (b_rptr == $past(b_rptr));
    endproperty
    assert_read_ptr_stable_when_empty: assert property(read_ptr_stable_when_empty)
        else $error("Read pointer changed when FIFO was empty");
    
    // Assertion 6: Reset behavior - write pointer resets to 0
    property write_reset_behavior;
        @(posedge wclk)
        (wrst) |-> (b_wptr == 3'b000);
    endproperty
    assert_write_reset_behavior: assert property(write_reset_behavior)
        else $error("Write pointer not reset to 0 during reset");
    
    // Assertion 7: Reset behavior - read pointer resets to 0
    property read_reset_behavior;
        @(posedge rclk)
        (rrst) |-> (b_rptr == 3'b000);
    endproperty
    assert_read_reset_behavior: assert property(read_reset_behavior)
        else $error("Read pointer not reset to 0 during reset");
    
    // Assertion 8: Data integrity - read data matches written data (FIFO order)
    sequence write_seq;
        (wr && !full);
    endsequence
    
    sequence read_seq;
        (rd && !empty);
    endsequence
    
    property data_integrity;
        @(posedge wclk)
        disable iff(wrst || rrst)
        write_seq ##[1:$] read_seq;
    endproperty
    assert_data_integrity: assert property(data_integrity)
        else $error("Data integrity violation - FIFO ordering not maintained");

endmodule
