`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 13:44:15
// Design Name: 
// Module Name: HazardDetection
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


module HazardDetection(
    input [4:0] RegSource_ID,
    input [4:0] RegTarget_ID,
    input [4:0] WriteRegAddr_EX,
    input [2:0] MemRead_EX,
    output reg PCWrite,
    output reg stall
    );
    
    always @(*) begin
        if((MemRead_EX != 3'b000) && ((WriteRegAddr_EX == RegSource_ID) || (WriteRegAddr_EX == RegTarget_ID))) begin
            stall = 1;
            PCWrite = 0;
        end else begin
            stall = 0;
            PCWrite = 1;
        end
    end
            
    
endmodule
