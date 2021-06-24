`include "IF/PC.sv"
`include "IF/instMem.sv"
`include "IF/instFetchReg.sv"
`timescale 1ns/1ns

module instFetch (
	input clk, rst, hazard,
	
	input [31:0] branch_address_IF,
	input B_EXE,

	output [31:0] instruction_ID, pc_ID
);

	wire [31:0] pc_next, pc, instruction, pc4;
	
	assign pc_next = (B_EXE) ? branch_address_IF : pc4;
	assign pc4 = pc + 32'd4;

	PC PC (clk, rst, hazard, pc_next, pc);
	instMem im (pc, instruction);
	instFetchReg pr_if_id (
		clk, rst,
		B_EXE, hazard, 
		instruction, pc4,
		instruction_ID, pc_ID
	);


endmodule