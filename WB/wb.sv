`timescale 1ns/1ns

module wb (
    input WB_EN_WB, MEM_R_EN_WB,
    input [31:0] alu_res_WB, data_WB,
    input [3:0] dest_WB,

    output [31:0] val
);

    assign val = MEM_R_EN_WB ? data_WB : alu_res_WB;
    
endmodule