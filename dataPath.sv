`include "IF/instFetch.sv"
`include "ID/instDecode.sv"
`include "EXE/exe.sv"
`include "MEM/mem.sv"
`include "WB/wb.sv"
`include "HAZARD/hazard.sv"
`include "FORWARD/forward.sv"
`timescale 1ns/1ns

module dataPath (
    input clk, clk_SRAM, rst, FWRD_EN,
    output integer inst_count,
    output reg stop
);

    wire [31:0] branch_address_IF;

    wire [31:0] instruction_ID, pc_ID;
    wire [3:0] status_ID;

    wire [31:0] pc_EXE, rn_val_EXE, rm_val_EXE;
    wire [23:0] signed_imm_24_EXE;
    wire [11:0] shifter_operand_EXE;
    wire [3:0] exe_cmd_EXE, dest_EXE, status_EXE;
    wire WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, S_EXE, B_EXE, imm_EXE;

    wire [31:0] alu_res_MEM, rm_val_MEM, data_MEM;
    wire [3:0] dest_MEM;
    wire WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM;

    wire [31:0] alu_res_WB, data_WB;
    wire [3:0] dest_WB;
    wire WB_EN_WB, MEM_R_EN_WB;

    wire [31:0] val_WB;

    wire [3:0] src1_HZRD, src2_HZRD;
    wire hazard, two_src_HZRD, move_HZRD;

    wire [3:0] src1_FWRD, src2_FWRD;
    wire [1:0] sel_src1_FWRD, sel_src2_FWRD;

    wire ready;
    
    instFetch IF (
        clk, rst, (hazard | ~ready),

        branch_address_IF,
        B_EXE,

	    instruction_ID, pc_ID
    );

    instDecode ID (
        clk, rst, hazard, ~ready,

        instruction_ID, pc_ID, val_WB,
        status_ID, dest_WB,
        WB_EN_WB,

        pc_EXE, rn_val_EXE, rm_val_EXE,
        signed_imm_24_EXE,
        shifter_operand_EXE,
        exe_cmd_EXE, dest_EXE, status_EXE,
        WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, S_EXE, B_EXE, imm_EXE,
        two_src_HZRD, move_HZRD,
        src1_FWRD, src2_FWRD,

        src1_HZRD, src2_HZRD
    );

    exe EXE (
        clk, rst, ~ready,

        pc_EXE, rn_val_EXE, rm_val_EXE, val_WB,
        signed_imm_24_EXE,
        shifter_operand_EXE,
        exe_cmd_EXE, dest_EXE, status_EXE,
        WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, B_EXE, S_EXE, imm_EXE,
        sel_src1_FWRD, sel_src2_FWRD,

        rm_val_MEM, branch_address_IF, alu_res_MEM,
        dest_MEM, status_ID,
        WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM
    );

    mem MEM (
        clk, rst, clk_SRAM,

        WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM,
        alu_res_MEM, rm_val_MEM,
        dest_MEM,

        WB_EN_WB, MEM_R_EN_WB,
        alu_res_WB, data_WB,
        dest_WB, ready
    );

    wb WB (
        WB_EN_WB, MEM_R_EN_WB,
        alu_res_WB, data_WB,
        dest_WB,

        val_WB
    );

    wire HZRD_DIS = (FWRD_EN && ~MEM_R_EN_EXE);
    hazard HAZARD (
        HZRD_DIS,
        move_HZRD,
        WB_EN_EXE, WB_EN_MEM,
        dest_EXE, dest_MEM,
        src1_HZRD, src2_HZRD,
        two_src_HZRD,

        hazard
    );

    forward FORWARD (
        FWRD_EN,
        WB_EN_MEM, WB_EN_WB,
        dest_MEM, dest_WB,
        src1_FWRD, src2_FWRD,
        sel_src1_FWRD, sel_src2_FWRD
    );

    initial begin
        inst_count = 0;
        stop = 0;
    end
    always @(posedge clk, posedge rst) begin
        if(~stop)$display("%d: %b", pc_ID/4, instruction_ID);
        if(rst) stop =0;
        else if(instruction_ID == 32'b1110_10_1_0_111111111111111111111111) begin
            stop = 1;
            inst_count = pc_ID / 4;
        end
    end

endmodule