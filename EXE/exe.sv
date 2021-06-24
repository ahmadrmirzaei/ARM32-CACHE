`include "EXE/ALU.sv"
`include "EXE/val2generator.sv"
`include "EXE/statusRegister.sv"
`include "EXE/exeReg.sv"
`timescale 1ns/1ns

module exe (
    input clk, rst, freeze,

    input [31:0] pc_EXE, rn_val_EXE, rm_val_EXE, val_WB,
    input [23:0] signed_imm_24_EXE,
    input [11:0] shifter_operand_EXE,
    input [3:0] exe_cmd_EXE, dest_EXE, status_EXE,
    input WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, B_EXE, S_EXE, imm_EXE,
    input [1:0] sel_src1_FWRD, sel_src2_FWRD,

    output [31:0] rm_val_MEM, branch_address_IF, alu_res_MEM,
    output [3:0] dest_MEM, status_ID,
    output WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM
);

    wire MEM_EN = MEM_R_EN_EXE | MEM_W_EN_EXE;
    assign branch_address_IF = {{6{signed_imm_24_EXE[23]}},signed_imm_24_EXE,2'b0} + pc_EXE;
    wire C = status_EXE[1];
    wire [31:0] val1 = (sel_src1_FWRD == 0) ? rn_val_EXE :
                       (sel_src1_FWRD == 1) ? alu_res_MEM :
                                              val_WB;

    wire [31:0] true_rm_val_EXE = (sel_src2_FWRD == 0) ? rm_val_EXE :
                                  (sel_src2_FWRD == 1) ? alu_res_MEM :
                                                         val_WB;

    wire [31:0] val2;
    wire [3:0] status_bits;
    wire [31:0] alu_res;

    val2generator v2g (
        true_rm_val_EXE,
        shifter_operand_EXE,
        imm_EXE, MEM_EN,
        val2
    );

    statusRegister sr (
        clk, rst,
        status_bits,
        S_EXE,
        status_ID
    );

    ALU alu (
        val1, val2,
        exe_cmd_EXE,
        C,
        alu_res,
        status_bits
    );

    exeReg pr_exe_mem (
        clk, rst, freeze,
        WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE,
        alu_res, true_rm_val_EXE,
        dest_EXE,
        WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM,
        alu_res_MEM, rm_val_MEM,
        dest_MEM
    );

endmodule