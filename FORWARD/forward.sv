`timescale 1ns/1ns

module forward (
    input FWRD_EN,
    input WB_EN_MEM, WB_EN_WB,
    input [3:0] dest_MEM, dest_WB,
    input [3:0] src1_FWRD, src2_FWRD,
    output reg [1:0] sel_src1_FWRD, sel_src2_FWRD
);

    always @(*) begin
        sel_src1_FWRD = 0;
        sel_src2_FWRD = 0;
        
        if(FWRD_EN) begin
            if(WB_EN_MEM && dest_MEM == src1_FWRD) sel_src1_FWRD = 1;
            else if(WB_EN_WB && dest_WB == src1_FWRD) sel_src1_FWRD = 2;

            if(WB_EN_MEM && dest_MEM == src2_FWRD) sel_src2_FWRD = 1;
            else if(WB_EN_WB && dest_WB == src2_FWRD) sel_src2_FWRD = 2;
        end
    end
    
endmodule