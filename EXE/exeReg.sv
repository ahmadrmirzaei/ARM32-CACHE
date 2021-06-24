`timescale 1ns/1ns

module exeReg (
    input clk, rst, freeze,

    input WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE,
    input [31:0] ALU_RES_EXE, VAL_RM_EXE,
    input [3:0] DEST_EXE,

    output reg WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM,
    output reg [31:0] ALU_RES_MEM, VAL_RM_MEM,
    output reg [3:0] DEST_MEM
);

    always @(posedge clk, posedge rst) begin
        if(rst)begin
            WB_EN_MEM <= 1'b0;
            MEM_R_EN_MEM <= 1'b0;
            MEM_W_EN_MEM <= 1'b0;
            ALU_RES_MEM <= 32'b0;
            VAL_RM_MEM <= 32'b0;
            DEST_MEM <= 4'b0;
        end
        else if(~freeze)begin
            WB_EN_MEM <= WB_EN_EXE;
            MEM_R_EN_MEM <= MEM_R_EN_EXE;
            MEM_W_EN_MEM <= MEM_W_EN_EXE;
            ALU_RES_MEM <= ALU_RES_EXE;
            VAL_RM_MEM <= VAL_RM_EXE;
            DEST_MEM <= DEST_EXE;
        end
    end
    
endmodule