`timescale 1ns/1ns

module ALU (
    input signed [31:0] val1, val2,
    input [3:0] EXE_CMD,
    input c,
    output signed [31:0] result,
    output reg [3:0] status_bits
);

    parameter MOV = 4'b0001;
    parameter MVN = 4'b1001;
    parameter ADD_LDR_STR = 4'b0010;
    parameter ADC = 4'b0011;
    parameter SUB_CMP = 4'b0100;
    parameter SBC = 4'b0101;
    parameter AND_TST = 4'b0110;
    parameter ORR = 4'b0111;
    parameter EOR = 4'b1000;

    reg [32:0] tmp;
    assign result = tmp[31:0];

    always @(*) begin
        case (EXE_CMD)
            MOV: begin
                tmp = val2;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
            MVN: begin
                tmp = ~val2;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
            ADD_LDR_STR: begin
                tmp = {val1[31],val1} + {val2[31],val2};
                status_bits = {tmp[31], (tmp == 32'b0), tmp[32], tmp[31]^tmp[32]};
            end
            ADC: begin
                tmp = {val1[31],val1} + {val2[31],val2} + c;
                status_bits = {tmp[31], (tmp == 32'b0), tmp[32], tmp[31]^tmp[32]};
            end
            SUB_CMP: begin
                tmp = {val1[31],val1} - {val2[31],val2};
                status_bits = {tmp[31], (tmp == 32'b0), tmp[32], tmp[31]^tmp[32]};
            end
            SBC: begin
                tmp = {val1[31],val1} - {val2[31],val2} - !c;
                status_bits = {tmp[31], (tmp == 32'b0), tmp[32], tmp[31]^tmp[32]};
            end
            AND_TST: begin
                tmp = val1 & val2;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
            ORR: begin
                tmp = val1 | val2;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
            EOR: begin
                tmp = val1 ^ val2;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
            default: begin
                tmp = 0;
                status_bits = {tmp[31], (tmp == 32'b0), 1'b0, 1'b0};
            end
        endcase
    end
    
endmodule