`timescale 1ns/1ns

module registerFile(
  input clk, rst,
  input WB_EN_ID,
  input [3:0] src1_HZRD, src2_HZRD, dest_ID,
  input [31:0] val_ID,
  output [31:0] rn_val, rm_val
);
  
  reg signed [31:0] regf [0:14];
  integer i;
  integer fd;
  
  assign rn_val = regf[src1_HZRD];
  assign rm_val = regf[src2_HZRD];

  initial begin
    fd = $fopen("./build/registers.txt", "w");
    $fdisplay(fd, "REGISTERS--------------------------------------------------------------------");
    for (i = 0; i<15; i=i+1) begin
      regf[i] = i;
      $fdisplay(fd, "%d: %d", i, regf[i]);
    end
    $fclose(fd);
  end
  
  always@(negedge clk, posedge rst) begin
    if (rst) for (i = 0; i<15; i=i+1) regf[i] = i;
    else if (WB_EN_ID) begin 
      regf[dest_ID] = val_ID;
      fd = $fopen("./build/registers.txt", "w");
      $fdisplay(fd, "REGISTERS--------------------------------------------------------------------");
      for (i = 0; i<15; i=i+1)
        $fdisplay(fd, "%d: %d", i, regf[i]);
      $fclose(fd);
    end
  end
  
endmodule