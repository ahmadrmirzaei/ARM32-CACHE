`timescale 1ns/1ns

module controlUnit(
  input [1:0] mode,
  input [3:0] opcode,
  input S_ID,
  input mux_cc,
  output reg [3:0] exe_cmd,
  output reg MEM_R_EN, MEM_W_EN, WB_EN, B, S,
  output reg move_HZRD
);

  always@(*) begin
    {exe_cmd, MEM_R_EN, MEM_W_EN, WB_EN, B, S, move_HZRD} = 10'd0;
    if(mux_cc==1'b1) {exe_cmd, MEM_R_EN, MEM_W_EN, WB_EN, B, S, move_HZRD} = 10'd0;
    // ----- Calculation Commands -----
    else if(mode==2'b00) begin
      case(opcode)
        //Move
        4'b1101: begin
          exe_cmd = 4'b0001;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b1;
        end
        //Move NOT
        4'b1111: begin
          exe_cmd = 4'b1001;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b1;
        end
        //Add
        4'b0100: begin
          exe_cmd = 4'b0010;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Add with Carry
        4'b0101: begin
          exe_cmd = 4'b0011;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Subtraction
        4'b0010: begin
          exe_cmd = 4'b0100;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Subtract with Carry
        4'b0110: begin
          exe_cmd = 4'b0101;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //And
        4'b0000: begin
          exe_cmd = 4'b0110;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Or
        4'b1100: begin
          exe_cmd = 4'b0111;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Exclusive OR
        4'b0001: begin
          exe_cmd = 4'b1000;
          S = S_ID;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0010;
          move_HZRD = 1'b0;
        end
        //Compare
        4'b1010: begin
          exe_cmd = 4'b0100;
          S = 1;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0000;
          move_HZRD = 1'b0;
        end
        //Test
        4'b1000: begin
          exe_cmd = 4'b0110;
          S = 1;
          {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0000;
          move_HZRD = 1'b0;
        end
        default: {exe_cmd, MEM_R_EN, MEM_W_EN, WB_EN, B, S, move_HZRD} = 10'd0;
      endcase
    end
    
    
    // ----- Load & Store -----
    else if(mode==2'b01) begin
      //Load Register
      if(S_ID==1) begin
        exe_cmd = 4'b0010;
        S = 0;
        {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b1010;
        move_HZRD = 0;
      end
      else begin
        exe_cmd = 4'b0010;
        S = 0;
        {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0100;
        move_HZRD = 0;
      end
    end
    
    
    // ----- Branch -----
    else if(mode==2'b10) begin
      exe_cmd = 4'b0000;
      S = 0;
      {MEM_R_EN, MEM_W_EN, WB_EN, B} = 4'b0001;
      move_HZRD = 1;
    end
    
    
  end
  
endmodule