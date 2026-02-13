module Async_FIFO #(parameter DEPTH = 8,DATAWIDTH =8)(
input wclk,rclk,
input wrst,rrst,
input er,rd,
input [DATAWIDTH-1 :0] wdata,
output [DATAWIDTH-1 :0] Rdata,
output full,empty
);

localparam PTR_WIDTH = $clog2(DEPTH);

wire [PTR_WIDTH-1:0] b_rptr,b_wptr,//binary pinter (FIFO accessing addresses)
                     g_rptr,g_wptr,//gray coded pointer
                     g_rptr_sync,g_wptr_sync;//gray coded pointers after double ff synchronizer

W_Handler #(PTR_WIDTH) Write_Handle(wclk,wrst,wr,g_rptr_sync,b_wptr,g_wptr,full);

R_Handler #(PTR_WIDTH) Read_Handle(rclk,rrst,rd,g_wptr_sync,b_rptr,g_rptr,empty);

Double_Flop_Synchronizer #(PTR_WIDTH) Write_Sync(rclk,rrst,g_wptr,g_wptr_sync);

Double_Flop_Synchronizer #(PTR_WIDTH) Read_Sync(wclk,wrst,g_rptr,g_rptr_sync);

DualPortMem #(DATAWIDTH,DEPTH,PTR_WIDTH) FIFO_MEM (wclk,rclk,wr,rd,full,empty,b_rptr,Wdata,Rdata);

endmodule
