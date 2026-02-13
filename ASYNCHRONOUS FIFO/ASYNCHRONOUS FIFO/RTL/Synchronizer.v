module Double_Flop_Synchronizer #(parameter WIDTH=4)(
input clk,
input reset,
input [WIDTH-1:0] D,
output reg [WIDTH-1:0] Q

);

reg [WIDTH-1:0] q;

always@(posedge clk,posedge reset)begin

	if(reset)begin
	Q <= {WIDTH{1'b0}};
	q <= {WIDTH{1'b0}};
	end else begin
	q <= D;
	Q <= q;
	end
end


endmodule
