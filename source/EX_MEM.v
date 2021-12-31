`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:03:27
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clock,
    
    input [2:0] MemRead_EX,
    input [1:0] MemWrite_EX,
    input       RegWrite_EX,
    input [1:0] WriteRegDataSignal_EX,
    input [31:0] AluResult_EX,
    input [31:0] WriteMemData_EX,
    input [4:0] WriteRegAddr_EX,
    input [31:0] Instruction_EX,
    input [2:0] WriteMemDataLength_EX,
    input [3:0] ReadMemExtSignal_EX,
    input [31:0] PC_EX,
    output reg [2:0] MemRead_MEM,            
    output reg [1:0] MemWrite_MEM,           
    output reg       RegWrite_MEM,           
    output reg [1:0] WriteRegDataSignal_MEM, 
    output reg [31:0] AluResult_MEM,         
    output reg [31:0] WriteMemData_MEM,      
    output reg [4:0] WriteRegAddr_MEM,      
    output reg [31:0] Instruction_MEM,
    output reg[2:0] WriteMemDataLength_MEM,
    output reg[3:0] ReadMemExtSignal_MEM,
    output reg[31:0] PC_MEM       
    );
    always @(posedge clock) begin
        MemRead_MEM              <=     MemRead_EX              ;
        MemWrite_MEM             <=     MemWrite_EX             ;
        RegWrite_MEM             <=     RegWrite_EX             ;
        WriteRegDataSignal_MEM   <=     WriteRegDataSignal_EX   ;
        AluResult_MEM            <=     AluResult_EX            ;
        WriteMemData_MEM         <=     WriteMemData_EX         ;
        WriteRegAddr_MEM         <=     WriteRegAddr_EX         ;
        Instruction_MEM          <=     Instruction_EX          ;
        WriteMemDataLength_MEM   <=     WriteMemDataLength_EX   ;
        ReadMemExtSignal_MEM     <=     ReadMemExtSignal_EX     ;
        PC_MEM                   <=     PC_EX;
    end 
endmodule
