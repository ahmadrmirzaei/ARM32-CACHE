`timescale 1ns/1ns

module PC (
	input clk, rst,
	input freeze,
  	input [31:0] pcIn,
  	output reg [31:0] pcOut
);

	initial pcOut = 32'd0;
	
	always@(posedge clk, posedge rst)begin
		if(rst) pcOut <= 32'd0;
		else if(~freeze) pcOut <= pcIn;
	end
  		  
endmodule

