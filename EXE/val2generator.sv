`timescale 1ns/1ns

module val2generator (
    input [31:0] rm_val,
    input [11:0] shifter_oprand,
    input imm, mem_en,

    output reg [31:0] val2
);

    wire [3:0] rotate_imm = shifter_oprand[11:8];
    wire [7:0] immed_8 = shifter_oprand[7:0];
    wire [4:0] shift_imm = shifter_oprand[11:7];
    wire [1:0] shift = shifter_oprand[6:5];
    wire fourth = shifter_oprand[4];
    wire [3:0] rm = shifter_oprand[3:0];
    
    integer i;

    parameter LSL = 0;
    parameter LSR = 1;
    parameter ASR = 2;
    parameter ROR = 3;

    always @(*) begin
        if(mem_en) val2 = {{20{shifter_oprand[11]}}, shifter_oprand};
        else begin
            if(imm)begin
                val2 = immed_8;
                for(i=0; i<rotate_imm; i=i+1)
                    val2 = {val2[1:0], val2[31:2]};
            end
            else begin
                val2 = rm_val;
                for (i=0; i<shift_imm; i=i+1) begin
                    case (shift)
                        LSL: val2 = {val2[30:0], 1'b0};
                        LSR: val2 = {1'b0, val2[31:1]};
                        ASR: val2 = {val2[31], val2[31:1]};
                        ROR: val2 = {val2[0], val2[31:1]};
                    endcase
                end
            end
        end
    end
endmodule