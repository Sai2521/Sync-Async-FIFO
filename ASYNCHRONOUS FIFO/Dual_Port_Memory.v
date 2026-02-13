module DualPortMem #(parameter DATAWIDTH = 8, parameter DEPTH = 8, parameter ADDR = $clog2(DEPTH))
(
input wclk, 
input rclk,
input wr,rd,
input full,empty,
input [ADDR-1:0] Waddr, // write address
input [ADDR-1:0] Raddr, // read address 
input [DATAWIDTH-1:0] Wdata,

output [DATAWIDTH-1:0] Rdata // Asynchronous read
);

// Memory 2D
reg [DATAWIDTH-1:0] MEM [0:DEPTH-1];

// Write Operation
always@(posedge wclk)
begin	
	if(wr && !full)
	begin
		MEM[Waddr] <= Wdata;
	end
	else ;
end

// Read Operation
assign Rdata = MEM[Raddr];

endmodule 
