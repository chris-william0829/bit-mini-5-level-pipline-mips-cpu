//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 16:18:49
// Design Name: 
// Module Name: NextPC
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


module NextPC(
    input [2:0] NextPCSignal,
    input [31:0] PC,
    input [31:0] PC_ID,
    input [25:0] JumpAddr_IF,
    input [25:0] JumpAddr_ID,
    input [31:0] JumpReg,
    output reg [31:0] NextPC
    );
    
    wire [31:0] NextPC_IF;
    assign NextPC_IF = PC + 4;
    always @(*) begin
        case (NextPCSignal)
          3'b000: NextPC = NextPC_IF;
          3'b001: NextPC =  NextPC_IF + { {14{JumpAddr_IF[15]}}, JumpAddr_IF[15:0], 2'b00};
          3'b010: NextPC = PC_ID;
          3'b011: NextPC =  {PC_ID[31:28], JumpAddr_ID[25:0], 2'b00};
          3'b100: NextPC = JumpReg;
          default: ;
        endcase    
    end
    
endmodule
