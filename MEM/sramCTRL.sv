`timescale 1ns/1ns

`define address_msb 31:1
`define address_word_offset 0

module sramCTRL (
    input clk, rst,

    input MEM_R_EN, MEM_W_EN,
    input [31:0] address, write_data,
    
    output [63:0] read_data,
    output ready,

    inout [31:0] data_SRAM,
    output [15:0] address_SRAM,
    output WE_N_SRAM
);

    integer cycle = 0;

    wire [31:0] address0;
    assign address0[`address_msb] = address[`address_msb];
    assign address0[`address_word_offset] = 0;

    wire [31:0] address1;
    assign address1[`address_msb] = address[`address_msb];
    assign address1[`address_word_offset] = 1;

    reg [31:0] data0;

    assign read_data = {data0, data_SRAM};
    assign ready = (cycle == 5) ? 1 : (MEM_W_EN || MEM_R_EN) ? 0 : 1;
    assign data_SRAM = WE_N_SRAM ? {32{1'bz}} : write_data;
    assign address_SRAM = MEM_R_EN ? (cycle<3) ? address0 : address1 : address;
    assign WE_N_SRAM = ~MEM_W_EN;

    always@(posedge clk, posedge rst) begin
        if (rst) cycle = 0;
        else if (MEM_W_EN || MEM_R_EN) begin
            if(cycle == 5) begin
                cycle = 0;
            end
            else cycle = cycle + 1;
            if(cycle == 2) data0 = data_SRAM;
        end
    end

endmodule