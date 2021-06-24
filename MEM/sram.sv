`timescale 1ns/1ns

module sram (
    input clk, rst,
    input WE_N_SRAM,
    input [15:0] address_SRAM,
    inout [31:0] data_SRAM
);

    parameter RAM_WIDTH = 32;                  // Specify RAM data width
    parameter RAM_DEPTH = 512;                  // Specify RAM depth (number of entries)

    reg signed [RAM_WIDTH-1:0] memory [0:RAM_DEPTH-1];
    integer i;
    integer fd;

    assign #30 data_SRAM = WE_N_SRAM ? memory[address_SRAM] : {RAM_WIDTH{1'bz}};

    initial begin
        fd = $fopen("./build/memory.txt", "w");
        $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
        for (i = 0; i<RAM_DEPTH; i=i+1) begin
            memory[i] = 0;
            $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
        end
        $fclose(fd);
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            fd = $fopen("./build/memory.txt", "w");
            $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
            for (i = 0; i<RAM_DEPTH; i=i+1) begin
                memory[i] = 0;
                $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
            end
            $fclose(fd);            
        end
        else if (~WE_N_SRAM) begin
            memory[address_SRAM] = data_SRAM;
            fd = $fopen("./build/memory.txt", "w");
            $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
            for (i = 0; i<RAM_DEPTH; i=i+1)
                $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
            $fclose(fd);
        end
    end
endmodule