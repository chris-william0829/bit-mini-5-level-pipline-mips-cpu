//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/27 16:01:14
// Design Name: 
// Module Name: SignExtension
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


module SignExtension(
    input[15:0] Imm16,
    input SignExtSignal,
    output[31:0] Imm32
    );
    
    assign Imm32 = (SignExtSignal) ? {{16{ Imm16[15] }},Imm16} : {16'd0,Imm16};
    
endmodule
