`include "dataPath.sv"
`timescale 1ns/1ns

module tb();

    reg rst = 0;
    reg clk = 0;
    reg clk_SRAM = 0;
    wire real inst_count;
    wire stop;
    real i;
    reg FWRD_EN = 1;
  
    dataPath uut (
        clk, clk_SRAM, rst, FWRD_EN,
        inst_count, stop
    );

    always begin 
        #10 clk = 1; clk_SRAM = ~clk_SRAM; i = i+1; #10 clk = 0;
        if(stop) begin
            for (integer j = 0; j < 20; j=j+1) begin
                #10 clk = 1; clk_SRAM = ~clk_SRAM; #10 clk = 0;
            end
            $display("number of instructions: %d", inst_count);
            $display("number of cycles: %d", i);
            $display("CPI: %f", i/inst_count);
            #10 $finish;
        end
    end

    initial begin
        i = 0;
        $dumpfile("build/test2.vcd");
        $dumpvars(0, uut);

        #10;
        rst = 1;
        #10
        rst = 0;
    end

endmodule