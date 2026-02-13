module R_Handler #(parameter PTR_WIDTH = 3)( // PTRWIDTH is log2(DEPTH)
input rclk,
input rrst,
input rd,
input [PTR_WIDTH-1:0] g_wptr_sync, // Gray coded wrtie pointer after synchronizer

output reg [PTR_WIDTH-1:0] b_rptr, // Binary read pointer (FIFO read address)
output [PTR_WIDTH-1:0] g_rptr, // Gray coded read pointer
output empty
);


// Binary pointer after passing gray to binary converter
wire [PTR_WIDTH-1:0] b_wptr_sync;


b2g #(PTR_WIDTH) b2g_write (.IN(b_rptr),.OUT(g_rptr));
g2b #(PTR_WIDTH) g2b_write (.IN(g_wptr_sync),.OUT(b_wptr_sync)); // This is considered extra hardware but need for pointers comparison

assign empty = (b_wptr_sync == b_rptr);

always@(posedge rclk,posedge rrst)
begin
	if(rrst)
	begin
		b_rptr <= {PTR_WIDTH{1'b0}};
	end
	else if(rd && !empty)begin
		b_rptr <= b_rptr + 1'b1;
	end
end
endmodule
