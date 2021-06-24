`timescale 1ns/1ns

`define tag 16:7
`define index 6:1
`define word_offset 0

`define lut 150
`define valid0 149
`define tag0 148:139
`define data0 138:107
`define data1 106:75
`define valid1 74
`define tag1 73:64
`define data2 63:32
`define data3 31:0

`define block0 149:75
`define block1 74:0
`define valid_B 74
`define tag_B 73:64
`define data_B 63:0

`define local0 63:32
`define local1 31:0

module cache (
    input clk, rst,

    input MEM_R_EN, MEM_W_EN,
    input [31:0] address_1024, write_data,

    input [63:0] read_data_SRAMC,
    input ready_SRAMC,

    output [31:0] read_data,
    output ready,

    output [31:0] address_SRAMC, write_data_SRAMC,
    output MEM_R_EN_SRAMC, MEM_W_EN_SRAMC
);

    integer fd;
    integer i;

    reg signed [150:0] memory [63:0];
    initial begin
        for (integer i=0; i<64; i++) begin
            memory[i][`lut] = 0;
            memory[i][`valid0] = 0;
            memory[i][`valid1] = 0;
        end
    end
    reg signed [74:0] tmp_B;

    wire [31:0] address = (address_1024 - 1024) >> 2;
    wire hit0 = memory[address[`index]][`valid0] ? (address[`tag] == memory[address[`index]][`tag0]) ? 1 : 0 : 0;
    wire hit1 = memory[address[`index]][`valid1] ? (address[`tag] == memory[address[`index]][`tag1]) ? 1 : 0 : 0;
    wire miss = ~hit0 & ~hit1;

    assign read_data = hit0 ? ~address[`word_offset] ? memory[address[`index]][`data0] : memory[address[`index]][`data1] :
                       hit1 ? ~address[`word_offset] ? memory[address[`index]][`data2] : memory[address[`index]][`data3] :
                       ~address[`word_offset] ? read_data_SRAMC[`local0] : read_data_SRAMC[`local1];
    assign ready = MEM_R_EN_SRAMC || MEM_W_EN_SRAMC ? ready_SRAMC : 1;
    assign address_SRAMC = address;
    assign write_data_SRAMC = write_data;
    assign MEM_R_EN_SRAMC = MEM_R_EN && miss;
    assign MEM_W_EN_SRAMC = MEM_W_EN;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for (i=0; i<64; i++) begin
                memory[i][`lut] = 0;
                memory[i][`valid0] = 0;
                memory[i][`valid1] = 0;
            end  
        end
        else if (MEM_R_EN_SRAMC && ready_SRAMC) begin
            tmp_B[`valid_B] = 1;
            tmp_B[`tag_B] = address[`tag];
            tmp_B[`data_B] = read_data_SRAMC;
            if(~memory[address[`index]][`lut]) memory[address[`index]][`block0] = tmp_B;
            else memory[address[`index]][`block1] = tmp_B;
            memory[address[`index]][`lut] = ~memory[address[`index]][`lut];
        end
        else if (hit0) begin
            if (MEM_W_EN) begin 
               if(~address[`word_offset]) memory[address[`index]][`data0] = write_data;
               else memory[address[`index]][`data1] = write_data;
            end
            memory[address[`index]][`lut] = 1;
        end
        else if (hit1) begin
            if (MEM_W_EN) begin 
               if(~address[`word_offset]) memory[address[`index]][`data2] = write_data;
               else memory[address[`index]][`data3] = write_data;
            end
            memory[address[`index]][`lut] = 0;
        end

        fd = $fopen("./build/cache.txt", "w");
        $fdisplay(fd, "CACHE--------------------------------------------------------------------");
        for (i = 0; i<64; i++) begin
            $fdisplay(
                fd,
                "%d: %b %d %d %d\t\t%b %d %d %d",
                i,
                memory[i][`valid0], memory[i][`tag0],
                $signed(memory[i][`data0]), $signed(memory[i][`data1]),
                memory[i][`valid1], memory[i][`tag1],
                $signed(memory[i][`data2]), $signed(memory[i][`data3])
            );
        end
        $fclose(fd);
    end

endmodule

