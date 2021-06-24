`timescale 1ns/1ns

module memReg(
    input clk, rst, freeze,

    input WB_EN_MEM, MEM_R_EN_MEM,
    input [31:0] alu_res_MEM, data,
    input [3:0] dest_MEM,

    output reg WB_EN_WB, MEM_R_EN_WB,
    output reg [31:0] alu_res_WB, data_WB,
    output reg [3:0] dest_WB
);

    always@(posedge clk, posedge rst) begin
        if(rst)begin
            dest_WB <= 0;
            data_WB <= 0;
            alu_res_WB <= 0;
            MEM_R_EN_WB <= 0;
            WB_EN_WB <= 0;
        end

        else if(~freeze) begin
            dest_WB <= dest_MEM;
            data_WB <= data;
            alu_res_WB <= alu_res_MEM;
            MEM_R_EN_WB <= MEM_R_EN_MEM;
            WB_EN_WB <= WB_EN_MEM;
        end
    end

endmodule 