//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 16:48:59
// Design Name: 
// Module Name: SOPC
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


module SOPC(
    input clock,
    input rstn
    );
    
    wire[31:0] Instruction;     //IM transmit to CPU
    wire[31:0] PC;              //CPU transmit to IM
    wire[1:0] MemWrite;        // write memory or not
    wire[31:0]MemDataAddr;      //Address write to DataMem
    wire[31:0] WriteMemData;     //Data write to DaraMem
    wire[31:0] ReadMemData;     // data read from data memory
    wire[2:0] WriteMemDataLength;       //sign (SB,SH,SW)'s data length 
    wire rst = ~rstn;
    
    InstructionMemory IM(PC[8:2],Instruction);
    
    CPU CPU(
        .clock(clock),.reset(rst),
        .instruction(Instruction),      //IM transmit to CPU
        .ReadMemData(ReadMemData),      //data read from data memory   load instructions
        .InstAddress(PC),               //instruction's Address
        .AluResult(MemDataAddr),        //load instructions Mem Address = alu result
        .MemWrite(MemWrite),            //signal write memory or not
        .WriteMemData(WriteMemData),    //Data write to DaraMem     SB,SW
        .WriteMemDataLength_MEM(WriteMemDataLength)     //signal (SB,SH,SW)'s data length 
    );
    
    DataMemory DM(MemDataAddr[8:2],MemWrite,WriteMemData,WriteMemDataLength,ReadMemData);
    
endmodule
