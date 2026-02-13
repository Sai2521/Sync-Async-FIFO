
module g2b #(parameter DATAWIDTH = 4)(input [DATAWIDTH-1:0] IN,output [DATAWIDTH-1:0] OUT);


// Keep the MSB as it is
assign OUT[DATAWIDTH - 1] = IN[DATAWIDTH - 1];

// XORing each subsequent output bit with its upnext gray bit 
genvar i;
generate
	for(i = DATAWIDTH-2; i >= 0; i = i - 1)begin
		assign OUT[i] = OUT[i+1] ^ IN[i];
	end
endgenerate

endmodule
