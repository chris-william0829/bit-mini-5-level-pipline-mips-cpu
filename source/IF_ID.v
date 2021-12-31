`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/29 16:46:54
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clock,
    input IF_Flush,
    input PCWrite,
    input [31:0] PC_IF,
    input [31:0] Instruction_IF,
    output reg[31:0] PC_ID,
    output reg[31:0] Instruction_ID
    );
    
    always @(posedge clock) begin
        if(IF_Flush) begin
            Instruction_ID <= `ZeroWord;
            PC_ID <= `ZeroWord;
        end else begin
            if(PCWrite) begin
                Instruction_ID <= Instruction_IF;
                PC_ID <= PC_IF;
            end
        end
    end
endmodule
