//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/29 10:07:55
// Design Name: 
// Module Name: BranchTest
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


module BranchTest(
    input [2:0] JumpSignal,
    input signed [31:0] BranchTestData1,
    input signed [31:0] BranchTestData2,
    input [5:0] Opcode_IF,
    input [5:0] Opcode_ID,
    input [5:0] Func_ID,
    output reg[2:0] NextPCSignal,
    output reg IF_Flush
    );
    
    always @(*) begin
        case (Opcode_ID)
          `BEQ_OP: begin
            if(BranchTestData1 != BranchTestData2) begin
              NextPCSignal = 3'b010;
              IF_Flush = 1;
            end else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
          end
          `BNE_OP: begin
            if(BranchTestData1 == BranchTestData2) begin
              NextPCSignal = 3'b010;
              IF_Flush = 1;
            end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
          end
          `BGTZ_OP: begin
            if(BranchTestData1 <= 0) begin
              NextPCSignal = 3'b010;
              IF_Flush = 1;
            end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
          end
          `BLEZ_OP: begin
            if(BranchTestData1 > 0) begin
              NextPCSignal = 3'b010;
              IF_Flush = 1;
            end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
          end
          `REGMIN: begin
            case (Func_ID)
              `BLTZ: if(BranchTestData1 >= 0) begin
                NextPCSignal = 3'b010;
                IF_Flush = 1;
              end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
              `BLTZAL: if(BranchTestData1 >= 0) begin
                NextPCSignal = 3'b010;
                IF_Flush = 1;
              end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
              `BGEZ: if(BranchTestData1 < 0) begin
                NextPCSignal = 3'b010;
                IF_Flush = 1;
              end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
              `BGEZAL: if(BranchTestData1 < 0) begin
                NextPCSignal = 3'b010;
                IF_Flush = 1;
              end  else begin
                NextPCSignal = 3'b000;
                IF_Flush = 0;
            end
              default: ;
            endcase
          end 
          default: ;
        endcase
    end
    
    always @(*) begin
        if(Opcode_IF == `BEQ_OP || Opcode_IF == `BNE_OP || Opcode_IF == `BGTZ_OP || Opcode_IF == `BLEZ_OP || Opcode_IF == `REGMIN) begin
            NextPCSignal = 3'b001;
            IF_Flush = 0;
        end else begin
            NextPCSignal = 3'b000;
            IF_Flush = 0;
        end
        if(JumpSignal == 3'b010 || JumpSignal == 3'b111) begin
            NextPCSignal = 3'b011;
            IF_Flush = 1;
        end
        if(JumpSignal == 3'b011|| JumpSignal == 3'b100) begin
            NextPCSignal = 3'b100;
            IF_Flush = 1;
        end
    end
    
endmodule
