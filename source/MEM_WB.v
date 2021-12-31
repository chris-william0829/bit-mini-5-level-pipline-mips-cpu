`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 15:16:58
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clock,
    input           RegWrite_MEM,
    input [1:0]     WriteRegDataSignal_MEM,
    input [31:0]    ReadMemData_MEM,
    input [31:0]    AluResult_MEM,
    input [4:0]     WriteRegAddr_MEM,
    input [31:0] Instruction_MEM,
    input [3:0]  ReadMemExtSignal_MEM,
    input [31:0] PC_MEM,
    output reg      RegWrite_WB,
    output reg[1:0] WriteRegDataSignal_WB,
    output reg[31:0]ReadMemData_WB,
    output reg[31:0]AluResult_WB,
    output reg[4:0] WriteRegAddr_WB,
    output reg[31:0] Instruction_WB,
    output reg[3:0] ReadMemExtSignal_WB,
    output reg[31:0] PC_WB
    );
    
    always @(posedge clock) begin
        RegWrite_WB            <=   RegWrite_MEM           ;
        WriteRegDataSignal_WB  <=   WriteRegDataSignal_MEM ;
        ReadMemData_WB         <=   ReadMemData_MEM        ;
        AluResult_WB           <=   AluResult_MEM          ;
        WriteRegAddr_WB        <=   WriteRegAddr_MEM       ;
        Instruction_WB         <=   Instruction_MEM        ;
        ReadMemExtSignal_WB    <=   ReadMemExtSignal_MEM   ;
        PC_WB                  <=   PC_MEM;
    end
    
endmodule
