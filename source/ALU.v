//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 19:14:56
// Design Name: 
// Module Name: ALU
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


module ALU(
    input signed [31:0] AluOperandA,
    input signed [31:0] AluOperandB,
    input [4:0] AluOpcode,
    input [2:0]MemRead,
    input [1:0]MemWrite,
    output reg signed [31:0] AluResult,
    output reg AluOverflowSignal,
    output reg[2:0] WriteMemDataLength,
    output reg[3:0] ReadMemExtSignal
    );
    initial begin
        WriteMemDataLength = 3'b000;
        ReadMemExtSignal = 4'b0000;
    end
   always @(*) begin
        case (AluOpcode)
           `ALU_NOP: AluResult = AluOperandA;
           `ALU_ADD: AluResult = AluOperandA + AluOperandB;
           `ALU_SUB: AluResult = AluOperandA - AluOperandB;
           `ALU_ADDU: AluResult = AluOperandA + AluOperandB;
           `ALU_SUBU: AluResult = AluOperandA - AluOperandB;
           `ALU_AND: AluResult = AluOperandA & AluOperandB;
           `ALU_OR: AluResult = AluOperandA | AluOperandB;
           `ALU_SLT: AluResult = (AluOperandA < AluOperandB) ? 32'd1 : 32'd0;
           `ALU_SLTU: AluResult = ({1'b0, AluOperandA} < {1'b0, AluOperandB}) ? 32'd1 : 32'd0;
           `ALU_NOR: AluResult = ~(AluOperandA | AluOperandB);
           `ALU_SLL: AluResult = AluOperandB << AluOperandA;
           `ALU_SRL: AluResult = AluOperandB >> AluOperandA;
           `ALU_SRA: AluResult = AluOperandB >>> AluOperandA;
           `ALU_SLLV: AluResult = AluOperandB << (AluOperandA[4:0]);
           `ALU_SRLV: AluResult = AluOperandB >> (AluOperandA[4:0]);
           `ALU_LUI: AluResult = AluOperandB << 16;
           `ALU_XOR: AluResult = AluOperandB ^ AluOperandA;
           `ALU_SRAV: AluResult = AluOperandB >>> (AluOperandA[4:0]);
           default: AluResult = AluOperandA;
        endcase
    end
        
    always @(*) begin
        if((AluOpcode == `ALU_ADD) || (AluOpcode == `ALU_SUB)) begin
            if(((AluOperandA[31]^AluOperandB[31])==0)&&(AluOperandA[31]!=AluResult[31])) begin
                AluOverflowSignal = 1'b1;
            end else begin
                AluOverflowSignal = 1'b0;
            end
        end else begin
            AluOverflowSignal = 1'b0;
        end
    end
    
    always @(*) begin
        if(MemRead == `LW) begin
            ReadMemExtSignal = `U_DWORD;
        end else if(MemRead == `LH) begin
            if(AluResult[1]) begin
                ReadMemExtSignal = `S_WORD_HIGH;
            end else begin
                ReadMemExtSignal = `S_WORD_LOW;
            end
        end else if(MemRead == `LHU) begin
            if(AluResult[1]) begin
                ReadMemExtSignal = `U_WORD_HIGH;
            end else begin
                ReadMemExtSignal = `U_WORD_LOW;
            end
        end else if(MemRead == `LB) begin
            case(AluResult[1:0])
                2'b00: ReadMemExtSignal = `S_BYTE_LOWEST;
                2'b01: ReadMemExtSignal = `S_BYTE_LOW;
                2'b10: ReadMemExtSignal = `S_BYTE_HIGH;
                2'b11: ReadMemExtSignal = `S_BYTE_HIGHEST;
            endcase
        end else if(MemRead == `LBU) begin
            case(AluResult[1:0])
                2'b00: ReadMemExtSignal = `U_BYTE_LOWEST;
                2'b01: ReadMemExtSignal = `U_BYTE_LOW;
                2'b10: ReadMemExtSignal = `U_BYTE_HIGH;
                2'b11: ReadMemExtSignal = `U_BYTE_HIGHEST;
            endcase
        end else ;
    end
    
    always @(*) begin
        case (MemWrite)
          `SW: WriteMemDataLength = `DWORD;
          `SH: begin
            if(AluResult[1]) begin
              WriteMemDataLength = `WORD_HIGH;
            end else begin
              WriteMemDataLength = `WORD_LOW;
            end
          end
          `SB: begin
            case (AluResult[1:0])
              2'b00: WriteMemDataLength = `BYTE_LOWEST;
              2'b01: WriteMemDataLength = `BYTE_LOW;
              2'b10: WriteMemDataLength = `BYTE_HIGH;
              2'b11: WriteMemDataLength = `BYTE_HIGHEST; 
              default: ;
            endcase
          end 
          default: ;
        endcase
    end
    
endmodule
