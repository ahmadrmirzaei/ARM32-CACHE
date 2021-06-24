`timescale 1ns/1ns

module instFetchReg (
	input clk, rst,
	input flush, freeze,
	input [31:0] instruction_IF, pc_IF,
	output reg [31:0] instruction_ID, pc_ID
);

	initial instruction_ID <= 0;

	always@(posedge clk, posedge rst)begin
		if(rst) begin
			instruction_ID <= 0;
			pc_ID <= 0;			
		end
		else if(~freeze)begin
			if(flush)begin
				instruction_ID <= 0;
				pc_ID <= 0;
			end
			else begin
				instruction_ID <= instruction_IF;
				pc_ID <= pc_IF;
			end	
		end
	end
	
endmodule

