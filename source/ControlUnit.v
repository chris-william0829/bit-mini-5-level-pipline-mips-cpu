//`timescale 1ns / 1ps
`include "ControlSignalDefine.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/27 17:26:46
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input [5:0] Opcode,
    input [5:0] Func,
    input [4:0] Branch,
    output reg RegWrite,
    output reg [1:0] MemWrite,
    output reg SignExt,
    output reg [4:0] AluOpcode,
    output reg [2:0] JumpSignal,
    output reg AluSrcASignal,
    output reg AluSrcBSignal,
    output reg [1:0] WriteRegDataSignal,
    output reg [1:0] WriteRegSignal,
    output reg [2:0] MemRead
    );
    
    reg [20:0] ControlSignal;
    initial begin
        ControlSignal = 0;
    end
    always @(*) begin 
        case (Opcode)
          `SPECIAL: begin
            case (Func)
                `ADD_FUNC: ControlSignal =   `ADD_CONTROL ;
                `ADDU_FUNC: ControlSignal =  `ADDU_CONTROL;
                `AND_FUNC: ControlSignal =   `AND_CONTROL ;
                `SUB_FUNC: ControlSignal =   `SUB_CONTROL ;
                `SUBU_FUNC: ControlSignal =  `SUBU_CONTROL;
                `OR_FUNC: ControlSignal =    `OR_CONTROL;
                `SLT_FUNC: ControlSignal =   `SLT_CONTROL ;
                `SLTU_FUNC: ControlSignal =  `SLTU_CONTROL;
                `JR_FUNC: ControlSignal =    `JR_CONTROL ;
                `JALR_FUNC: ControlSignal =  `JALR_CONTROL;
                `NOR_FUNC: ControlSignal =   `NOR_CONTROL ;
                `SLL_FUNC: ControlSignal =   `SLL_CONTROL ;
                `SRL_FUNC: ControlSignal =   `SRL_CONTROL ;
                `SRA_FUNC: ControlSignal =   `SRA_CONTROL ;
                `SRAV_FUNC: ControlSignal =  `SRAV_CONTROL;
                `SRLV_FUNC: ControlSignal =  `SRLV_CONTROL;
                `XOR_FUNC: ControlSignal =   `XOR_CONTROL ;
                `SLLV_FUNC: ControlSignal =  `SLLV_CONTROL;
                default: ;
            endcase
          end
          `ADDI_OP:  ControlSignal = `ADDI_CONTROL;  
          `ORI_OP :  ControlSignal = `ORI_CONTROL ;  
          `LW_OP  :  ControlSignal = `LW_CONTROL  ;  
          `ADDIU_OP:  ControlSignal = `ADDIU_CONTROL;
          `SW_OP  :  ControlSignal = `SW_CONTROL  ;  
          `BEQ_OP :  ControlSignal = `BEQ_CONTROL ;  
          `BGTZ_OP:  ControlSignal = `BGTZ_CONTROL;  
          `BLEZ_OP:  ControlSignal = `BLEZ_CONTROL;  
          `BNE_OP :  ControlSignal = `BNE_CONTROL ;  
          `SLTI_OP:  ControlSignal = `SLTI_CONTROL;  
          `LUI_OP :  ControlSignal = `LUI_CONTROL ;  
          `ANDI_OP:  ControlSignal = `ANDI_CONTROL;  
          `LB_OP  :  ControlSignal = `LB_CONTROL  ;  
          `LBU_OP :  ControlSignal = `LBU_CONTROL ;  
          `LH_OP  :  ControlSignal = `LH_CONTROL  ;  
          `LHU_OP :  ControlSignal = `LHU_CONTROL ;  
          `SB_OP  :  ControlSignal = `SB_CONTROL  ;  
          `SH_OP  :  ControlSignal = `SH_CONTROL  ;  
          `J_OP   :  ControlSignal = `J_CONTROL; 
          `JAL_OP :  ControlSignal = `JAL_CONTROL ;  
          `REGMIN : begin
            case (Branch)
                `BLTZ  :ControlSignal = `BLTZ_CONTROL  ;
                `BLTZAL:ControlSignal = `BLTZAL_CONTROL;
                `BGEZ  :ControlSignal = `BGEZ_CONTROL  ;
                `BGEZAL:ControlSignal = `BGEZAL_CONTROL;
              default: ;
            endcase
          end
          default: ;
        endcase
    end
    
    always @(*) begin
        RegWrite = ControlSignal[20];
        MemWrite = ControlSignal[19:18];
        SignExt = ControlSignal[17];
        AluOpcode = ControlSignal[16:12];
        JumpSignal = ControlSignal[11:9];
        AluSrcASignal = ControlSignal[8];
        AluSrcBSignal = ControlSignal[7];
        WriteRegDataSignal = ControlSignal[6:5];
        WriteRegSignal = ControlSignal[4:3];
        MemRead = ControlSignal[2:0];
    end
    
endmodule
