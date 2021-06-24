`include "MEM/cache.sv"
`include "MEM/sram.sv"
`include "MEM/sramCTRL.sv"
`include "MEM/memReg.sv"
`timescale 1ns/1ns

module mem (
    input clk, rst, clk_SRAM,

    input WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM,
    input [31:0] alu_res_MEM, rm_val_MEM,
    input [3:0] dest_MEM,

    output WB_EN_WB, MEM_R_EN_WB,
    output [31:0] alu_res_WB, data_WB,
    output [3:0] dest_WB,
    output ready
);

    wire [31:0] read_data, data_SRAM;
    wire [15:0] address_SRAM;
    wire WE_N_SRAM;

    wire [63:0] read_data_SRAMC;
    wire ready_SRAMC;
    wire [31:0] address_SRAMC, write_data_SRAMC;
    wire MEM_R_EN_SRAMC, MEM_W_EN_SRAMC;

    cache cache (
        clk, rst,

        MEM_R_EN_MEM, MEM_W_EN_MEM,
        alu_res_MEM, rm_val_MEM,

        read_data_SRAMC,
        ready_SRAMC,

        read_data,
        ready,

        address_SRAMC, write_data_SRAMC,
        MEM_R_EN_SRAMC, MEM_W_EN_SRAMC
    );

    sramCTRL sram_ctrl (
        clk, rst,

        MEM_R_EN_SRAMC, MEM_W_EN_SRAMC,
        address_SRAMC, write_data_SRAMC,

        read_data_SRAMC,
        ready_SRAMC,

        data_SRAM,
        address_SRAM,
        WE_N_SRAM
    );

    sram sram (
        clk_SRAM, rst,
        WE_N_SRAM,
        address_SRAM,
        data_SRAM
    );

    memReg pr_mem_wb (
        clk, rst, ~ready,

        WB_EN_MEM, MEM_R_EN_MEM,
        alu_res_MEM, read_data,
        dest_MEM,

        WB_EN_WB, MEM_R_EN_WB,
        alu_res_WB, data_WB,
        dest_WB
    );

    
endmodule