module W_Handler #(parameter PTR_WIDTH = 3)( // PTRWIDTH is log2(DEPTH)
input wclk,
input wrst,
input wr,
input [PTR_WIDTH-1:0] g_rptr_sync, // Gray coded read pointer after double flop synchronizer

output reg [PTR_WIDTH-1:0] b_wptr, // Binary write pointer (FIFO write address)
output [PTR_WIDTH-1:0] g_wptr, // Gray coded write pointer before synchronizer
output full
);

// Binary pointer after passing gray to binary converter
wire [PTR_WIDTH-1:0] b_rptr_sync;
wire wrap_around; // Handling FIFO wrapping around

b2g #(PTR_WIDTH) b2g_write (.IN(b_wptr),.OUT(g_wptr));
g2b #(PTR_WIDTH) g2b_write (.IN(g_rptr_sync),.OUT(b_rptr_sync)); // This is considered extra hardware but need for pointers comparison

assign wrap_around = b_rptr_sync[PTR_WIDTH-1] ^ b_wptr[PTR_WIDTH-1];

assign full = wrap_around & (b_wptr[PTR_WIDTH-2:0] == b_rptr_sync[PTR_WIDTH-2:0]);

always@(posedge wclk,posedge wrst)
begin
	if(wrst)
	begin
		b_wptr <= {PTR_WIDTH{1'b0}};
	end
	else if(wr && !full)begin
		b_wptr <= b_wptr + 1'b1;
	end
end

endmodule
