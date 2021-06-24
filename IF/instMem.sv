`timescale 1ns/1ns

module instMem (
	input [31:0] address,
	output [31:0] instruction
);
	
	reg [31:0] instructions [0:46];
	initial $readmemb("instructions.txt", instructions);
	
	assign instruction = instructions[address/4];
	 
endmodule