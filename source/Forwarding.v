`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/29 16:12:45
// Design Name: 
// Module Name: Forwarding
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


module Forwarding(
    input [2:0] JumpSignal,
    input [4:0] RegSource_ID,
    input [4:0] RegTarget_ID,
    input [4:0] RegSource_EX,
    input [4:0] RegTarget_EX,
    input [4:0] WriteRegAddr_EX,
    input [4:0] WriteRegAddr_MEM,
    input [4:0] WriteRegAddr_WB,
    input [2:0] MemRead_MEM,
    input       RegWrite_EX,
    input       RegWrite_MEM,
    input       RegWrite_WB,
    output reg[1:0] ForwardASignal,
    output reg[1:0] ForwardBSignal,
    output reg[1:0] ForwardCSignal,
    output reg[1:0] ForwardDSignal,
    output reg[1:0] ForwardESignal
    );
    
    always @(*) begin
        if(((RegWrite_MEM == 1) && (WriteRegAddr_MEM != 0)) &&(WriteRegAddr_MEM == RegSource_EX)) 
            ForwardASignal = 2'b10;
        else if(((RegWrite_WB == 1) && (WriteRegAddr_WB != 0))&&(WriteRegAddr_WB == RegSource_EX) && !((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegSource_EX)))
            ForwardASignal = 2'b01;
        else ForwardASignal = 2'b00;
        
        if((RegWrite_MEM == 1) && (WriteRegAddr_MEM != 0) &&(WriteRegAddr_MEM == RegTarget_EX)) 
            ForwardBSignal = 2'b10;
        else if(((RegWrite_WB == 1) && (WriteRegAddr_WB != 0))&&(WriteRegAddr_WB == RegTarget_EX) && !((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegTarget_EX)))
            ForwardBSignal = 2'b01;
        else ForwardBSignal = 2'b00;
        
        if((RegWrite_EX && WriteRegAddr_EX != 0) && (WriteRegAddr_EX == RegSource_ID))
            ForwardCSignal = 2'b01;
        else if((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegSource_ID) && !((RegWrite_EX && WriteRegAddr_EX != 0) && (WriteRegAddr_EX == RegSource_ID)))
             ForwardCSignal = 2'b10;
        else if(((RegWrite_WB == 1) && (WriteRegAddr_WB != 0))&&(WriteRegAddr_WB == RegSource_ID) && !((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegSource_ID)))
            ForwardCSignal = 2'b11;
        else ForwardCSignal = 2'b00;
        
        if((RegWrite_EX && WriteRegAddr_EX != 0) && (WriteRegAddr_EX == RegTarget_ID))
            ForwardDSignal = 2'b01;
        else if((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegTarget_ID) && !((RegWrite_EX && WriteRegAddr_EX != 0) && (WriteRegAddr_EX == RegTarget_ID)))
             ForwardDSignal = 2'b10;
        else if(((RegWrite_WB == 1) && (WriteRegAddr_WB != 0))&&(WriteRegAddr_WB == RegTarget_ID) && !((RegWrite_MEM && WriteRegAddr_MEM != 0) && (WriteRegAddr_MEM == RegTarget_ID)))
            ForwardDSignal = 2'b11;
        else ForwardDSignal = 2'b00;
    
        if(RegWrite_EX && (JumpSignal == 3'b011 || JumpSignal == 3'b100)) begin
            if(MemRead_MEM != 3'b000)
                ForwardESignal = 2'b01;
            else if(RegSource_ID == WriteRegAddr_EX)
                ForwardESignal = 2'b10;
            else if(RegSource_ID == WriteRegAddr_MEM)
                ForwardESignal = 2'b11;
            end
        else ForwardESignal = 2'b00;
    end
    
endmodule
