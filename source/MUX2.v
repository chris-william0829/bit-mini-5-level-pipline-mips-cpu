//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/27 14:12:02
// Design Name: 
// Module Name: MUX2
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


module MUX2 #(parameter bits = 4)(
    input [bits-1:0] DataIn0,
    input [bits-1:0] DataIn1,
    input Signal,
    output [bits-1:0] DataOut
    );
    
    assign DataOut = (Signal == 1'b0) ? DataIn0 : DataIn1;
    
endmodule
