//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/27 20:29:08
// Design Name: 
// Module Name: sopc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sopc_tb(

    );
    
    reg clk,rstn;
    SOPC SOPC(clk,rstn);
   
    initial begin
      clk = 0;
      rstn = 0;
     $readmemh( "C:/CPU/5-level-pipline-mips-cpu/test/test_fun.dat" , SOPC.IM.InstMem); // load instructions into instruction memory
      //$readmemh( "mipstest_extloop.dat" , U_SCCOMP.U_IM.ROM); // load instructions into instruction memory
      $monitor("PC = 0x%8X, instr = 0x%8X", SOPC.PC, SOPC.CPU.Instruction_ID); // used for debug
      #50
      clk = ~clk;
      #50
      rstn = 1;
    forever #50  
    begin
      clk = ~clk;
    end
  end
	   

endmodule
