//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 18:29:48
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input [8:2] MemDataAddr,
    input [1:0] MemWrite,
    input [31:0] WriteMemData,
    input [2:0] WriteMemDataLength,
    output[31:0] ReadMemData
    );
    
    reg[31:0] DataMem[127:0];
    always @(*) begin
        if(MemWrite != `NOW) begin
              case (WriteMemDataLength)
                  `DWORD: DataMem[MemDataAddr] = WriteMemData;
                  `WORD_LOW: DataMem[MemDataAddr] = {16'b0,WriteMemData[15:0]};
                  `WORD_HIGH: DataMem[MemDataAddr] = {WriteMemData[15:0],16'b0};
                  `BYTE_LOWEST: DataMem[MemDataAddr] = {24'b0,WriteMemData[7:0]};
                  `BYTE_LOW: DataMem[MemDataAddr] ={16'b0, WriteMemData[7:0],8'b0};
                  `BYTE_HIGH: DataMem[MemDataAddr] ={8'b0, WriteMemData[7:0],16'b0};
                  `BYTE_HIGHEST: DataMem[MemDataAddr] = {WriteMemData[7:0],24'b0};
                    default: DataMem[MemDataAddr] = `ZeroWord;
              endcase
              $display("dmem[0x%8X] = 0x%8X,", MemDataAddr << 2, WriteMemData); 
          end
      end
      assign ReadMemData = DataMem[MemDataAddr];
endmodule
