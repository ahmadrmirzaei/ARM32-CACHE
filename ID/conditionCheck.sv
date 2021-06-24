`timescale 1ns/1ns

module conditionCheck(
  input [3:0] cond,
  input [3:0] status_ID,
  output reg check_cc
);
  
  wire N, Z, C, V;
  assign N = status_ID[3];
  assign Z = status_ID[2];
  assign C = status_ID[1];
  assign V = status_ID[0];
  
  always@(*)begin
      check_cc = 1'b0;
    case(cond)
      // EQ
      4'b0000: begin
        if(Z==1'b1)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // NE
      4'b0001: begin
        if(Z==1'b0)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      // CS/HS
      4'b0010: begin
        if(C==1'b1)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // CC/LO
      4'b0011: begin
        if(C==1'b0)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // MI
      4'b0100: begin
        if(N==1'b1)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // PL
      4'b0101: begin
        if(N==1'b0)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // VS
      4'b0110: begin
        if(V==1'b1)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      //VC
      4'b0111: begin
        if(V==1'b0)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // HI
      4'b1000: begin
        if(C==1'b1 && Z==1'b0)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      //LS
      4'b1001: begin
        if(C==1'b0 || Z==1'b1)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // GE
      4'b1010: begin
        if(N==V)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // LT
      4'b1011: begin
        if(N!=V)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // GT
      4'b1100: begin
        if(Z==1'b0 && N==V)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // LE
      4'b1101: begin
        if(Z==1'b1 || N!=V)
          check_cc = 1'b1;
        else
          check_cc = 1'b0;
      end
      
      // AL
      4'b1110: begin
        check_cc = 1'b1;
      end

      // def
      4'b1111: begin
        check_cc = 1'b0;
      end
    endcase
  end
  
endmodule 
