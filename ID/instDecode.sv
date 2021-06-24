`include "ID/controlUnit.sv"
`include "ID/conditionCheck.sv"
`include "ID/registerFile.sv"
`include "ID/instDecodeReg.sv"
`timescale 1ns/1ns

module instDecode(
  input clk, rst, hazard, freeze,

  input[31:0] instruction_ID, pc_ID, val,
  input[3:0] status_ID, dest_WB,
  input WB_EN_WB,

  output [31:0] pc_EXE, rn_val_EXE, rm_val_EXE,
  output [23:0] signed_imm_24_EXE,
  output [11:0] shifter_operand_EXE,
  output [3:0] exe_cmd_EXE, dest_EXE, status_EXE,
  output WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, S_EXE, B_EXE, imm_EXE,
  output two_src_HZRD, move_HZRD,
  output [3:0] src1_FWRD, src2_FWRD, src1_HZRD, src2_HZRD
);


  wire [3:0] cond = instruction_ID[31:28];
  wire [1:0] mode = instruction_ID[27:26];
  wire imm = instruction_ID[25];
  wire [3:0] opcode = instruction_ID[24:21];
  wire s_ID = instruction_ID[20];
  wire [3:0] rn = instruction_ID[19:16];
  wire [3:0] rd = instruction_ID[15:12];
  wire [3:0] rm = instruction_ID[3:0];
  wire [3:0] rs = instruction_ID[11:8];
  wire [11:0] shifter_operand = instruction_ID[11:0];
  wire [23:0] signed_imm_24 = instruction_ID[23:0];


  wire check_cc;
  conditionCheck cc(
    cond,
    status_ID,
    check_cc
  );
  wire mux_cc = ~check_cc | hazard;


  wire [3:0] exe_cmd;
  wire WB_EN, MEM_R_EN, MEM_W_EN, B, S;
  controlUnit ctrl (
    mode,
    opcode,
    s_ID,
    mux_cc,
    exe_cmd,
    MEM_R_EN, MEM_W_EN, WB_EN, B, S,
    move_HZRD
  );


  assign src1_HZRD = rn;
  assign src2_HZRD = MEM_W_EN ? rd : rm;
  assign two_src_HZRD = ~imm | MEM_W_EN;

  wire [31:0] rn_val, rm_val;
  registerFile rf (
    clk, rst,
    WB_EN_WB,
    src1_HZRD, src2_HZRD, dest_WB,
    val,
    rn_val, rm_val
  );

  instDecodeReg pr_id_exe (
    clk, rst, B_EXE, freeze,
    
    WB_EN, MEM_R_EN, MEM_W_EN,
    S, B,
    exe_cmd,
    pc_ID,
    rn_val, rm_val,
    imm,
    shifter_operand,
    signed_imm_24,
    rd,
    status_ID,
    src1_HZRD, src2_HZRD,

    WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE,
    S_EXE, B_EXE,
    exe_cmd_EXE, pc_EXE,
    rn_val_EXE, rm_val_EXE,
    imm_EXE,
    shifter_operand_EXE,
    signed_imm_24_EXE,
    dest_EXE,
    status_EXE,
    src1_FWRD, src2_FWRD
  );
  
endmodule
