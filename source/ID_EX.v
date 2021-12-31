//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/29 15:38:46
// Design Name: 
// Module Name: IR
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


module ID_EX(
    input clock,
    input stall,
    input [1:0] WriteRegSignal_ID,
    input [1:0] WriteRegDataSignal_ID,
    input       AluSrc1Signal_ID,
    input       AluSrc2Signal_ID,
    input [4:0] AluOpcode_ID,
    input [1:0] MemWrite_ID,
    input [2:0] MemRead_ID,
    input       RegWrite_ID,
    
    input [31:0] ReadRegData1_ID,
    input [31:0] ReadRegData2_ID,
    input [31:0] Shamt_ID,
    input [31:0] Imm32_ID,
    input [4:0]  RegSource_ID,
    input [4:0]  RegTarget_ID,
    input [4:0]  RegDst_ID,
    input [31:0] Instruction_ID,
    input [31:0] PC_ID,
    input [2:0] JumpSignal_ID,
    
    output reg [1:0] WriteRegSignal_EX,
    output reg [1:0] WriteRegDataSignal_EX,
    output reg       AluSrc1Signal_EX,
    output reg       AluSrc2Signal_EX,
    output reg [4:0] AluOpcode_EX,
    output reg [1:0] MemWrite_EX,
    output reg [2:0] MemRead_EX,
    output reg       RegWrite_EX,
    output reg [31:0] ReadRegData1_EX,
    output reg [31:0] ReadRegData2_EX,
    output reg [31:0] Shamt_EX,
    output reg [31:0] Imm32_EX,
    output reg [4:0]  RegSource_EX,
    output reg [4:0]  RegTarget_EX,
    output reg [4:0]  RegDst_EX,
    output reg [31:0] Instruction_EX,
    output reg [31:0] PC_EX,
    output reg [2:0] JumpSignal_EX
    );
    
    always @(posedge clock) begin
        ReadRegData1_EX <= ReadRegData1_ID;
        ReadRegData2_EX <= ReadRegData2_ID;
        Shamt_EX        <= Shamt_ID       ;
        Imm32_EX        <= Imm32_ID       ;
        RegSource_EX    <= RegSource_ID   ;
        RegTarget_EX    <= RegTarget_ID   ;
        RegDst_EX       <= RegDst_ID      ;
        Instruction_EX  <= Instruction_ID ;
        PC_EX           <= PC_ID          ;
        JumpSignal_EX   <= JumpSignal_ID  ;
        
        if(stall) begin
            WriteRegSignal_EX <= 0;
            WriteRegDataSignal_EX <= 0;
            AluSrc1Signal_EX <= 0;
            AluSrc2Signal_EX <= 0;
            AluOpcode_EX     <= 0;
            MemWrite_EX      <= 0;
            MemRead_EX     <= 0;
            RegWrite_EX      <= 0;
        end else begin
           WriteRegSignal_EX <=    WriteRegSignal_ID;
           WriteRegDataSignal_EX <= WriteRegDataSignal_ID;
            AluSrc1Signal_EX  <=    AluSrc1Signal_ID;
            AluSrc2Signal_EX  <=    AluSrc2Signal_ID;
                AluOpcode_EX  <=        AluOpcode_ID;
                 MemWrite_EX  <=         MemWrite_ID;
                  MemRead_EX  <=          MemRead_ID;
                 RegWrite_EX  <=         RegWrite_ID;
        end
    end
    
endmodule
