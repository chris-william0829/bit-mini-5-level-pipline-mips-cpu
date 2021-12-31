//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/25 20:38:15
// Design Name: 
// Module Name: PC
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


module PC(
    input clock,
    input reset,
    input PCWrite,
    input [31:0] NextPC,
    output [31:0] PC
    );
    reg[31:0] CurrentPC;
    initial CurrentPC = `ZeroWord;
    always @ (posedge clock,posedge reset)
        if(reset)
            CurrentPC <= 32'h00400000;
        else begin
            if(PCWrite) begin
                CurrentPC = NextPC;
                $display(" CurrentPC :0x%x ", CurrentPC);
            end
     end
     assign PC = CurrentPC;
    
endmodule
