module FIFO_assertions(FIFO_if.DUT FIFOif);

////////////////////////////////Assertions///////////////////////////////
property reset_p;
	@(posedge FIFOif.clk)
    !FIFOif.rst_n |-> (FIFO_DUT.count==0 && !FIFOif.overflow && !FIFOif.underflow && !FIFOif.full && FIFOif.empty && !FIFOif.almostfull && !FIFOif.almostempty && !FIFOif.wr_ack); 
endproperty

property overflow_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFOif.wr_en && FIFO_DUT.count==8) |=> (FIFOif.overflow && !FIFOif.wr_ack);
endproperty

property underflow_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFOif.rd_en && FIFO_DUT.count==0) |=> (FIFOif.underflow);
endproperty

property wr_ack_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFO_DUT.count!=8 && FIFOif.wr_en) |=> FIFOif.wr_ack; 
endproperty

property full_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFO_DUT.count==8) |-> FIFOif.full;
endproperty

property empty_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFO_DUT.count==0) |-> FIFOif.empty;
endproperty

property almostfull_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFO_DUT.count==7) |-> FIFOif.almostfull;
endproperty

property almostempty_p;
	@(posedge FIFOif.clk)
    disable iff (!FIFOif.rst_n) (FIFO_DUT.count==1) |-> FIFOif.almostempty;
endproperty

reset_assertion: assert property(reset_p);
overflow_assertion: assert property(overflow_p);
underflow_assertion: assert property(underflow_p);
wr_ack_assertion: assert property(wr_ack_p);
full_assertion: assert property(full_p);
empty_assertion: assert property(empty_p);
almostfull_assertion: assert property(almostfull_p);
almostempty_assertion: assert property(almostempty_p);

reset_coverage: cover property(reset_p);
overflow_coverage: cover property(overflow_p);
underflow_coverage: cover property(underflow_p);
wr_ack_coverage: cover property(wr_ack_p);
full_coverage: cover property(full_p);
empty_coverage: cover property(empty_p);
almostfull_coverage: cover property(almostfull_p);
almostempty_coverage: cover property(almostempty_p);

endmodule
