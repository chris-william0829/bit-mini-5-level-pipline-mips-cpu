//timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/25 20:52:46
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clock,
    input reset,
    input [31:0] instruction,
    input [31:0] ReadMemData,     // data read from data memory
    output [31:0] InstAddress,               // instruction address
    output [31:0] AluResult,       // ALU operated result
    output [1:0]MemWrite,        // write memory or not
    output [31:0] WriteMemData,   // data write to data memory      //SB,SW data from rt
    output [2:0] WriteMemDataLength_MEM     //sign (SB,SH,SW)'s data length 
    );
    wire[2:0] MemRead;           // read Memory or not (lw,lh,lhu,lb,lbu)
    wire RegWrite;               //write register or not
    wire SignExt;               //extend sign or not
    wire [2:0] NextPCSignal;       //next instruction address op
    wire [2:0] JumpSignal;              //ControlUnit signal of jump instruction's type
    wire [1:0] WriteRegDataSignal;         //Mux4 signal to select what data write to register 
    wire [1:0] WriteRegSignal;          //Mux4 signal to select what register write to
    
    wire [31:0] NextInstAddress;        //next instruction address
    wire [4:0] RegDst;                  //(R-type instruction's destination register, rs+rt->rd)
    wire [4:0] RegTarget;               //R-type instruction's source register,I-type instruction's destination register rs+imm->rt
    wire [4:0] RegSource;               //source register
    wire [5:0] Opcode;                  //instruction's opcode
    wire [5:0] Func;                    //instruction's function
    wire [31:0] Shamt;                   //instruction's offest
    wire [15:0] Imm16;                  //16bits immediate number
    wire [31:0] Imm32;                  //imm16 extended 32-bits immediate number
    wire [25:0] JumpAddr;               //J-type instruction's jump address
    
    wire[4:0] WriteRegAddr;             //write to which Registers
    wire[31:0] WriteRegData;            //data write to registers
    
    wire [31:0] ReadRegData1_ID;
    wire [31:0] ReadRegData2_ID;
    wire [31:0] ReadRegData1_EX;
    wire [31:0] ReadRegData2_EX;
    wire [31:0] Shamt_ID;
    wire [1:0] MemWrite_ID;
    wire [31:0] Shamt_EX;
    wire [4:0] RegDst_ID;   
    wire [4:0] RegTarget_ID;
    wire [4:0] RegSource_ID;
    wire [4:0] RegDst_EX;   
    wire [4:0] RegTarget_EX;
    wire [4:0] RegSource_EX;
    
    wire [31:0] AluResult_EX;
    
    wire [4:0] AluOpcode;               //ALU OP
    wire[31:0] AluOperandA;                  //operand of ALU A
    wire[31:0] AluOperandB;                 //operand of ALU B
    wire  AluSrcASignal;                 //Mux2 signal to select what data transimit to ALUSrcA
    wire  AluSrcBSignal;                 //Mux2 signal to select what data transimit to ALUSrcB
    wire AluOverflowSignal;             //ALU output overflow signal
    
    wire[31:0] MemDataExt;                  //(lb,lbu,lh,lhu,lw) instruction's result Extend(ReadMemData) -> MemData
    wire[3:0] ReadMemExtSignal;             //control how to ext MemData
    
    wire RegimmSignal;      //bltzal,bgez,bgezal rt!=0 but should compare with zero
    
    wire PCWrite;           //Control PC whether continue to update or not ()
    wire IF_Flush;
    wire stall;
    
    wire [31:0] PC_ID;
    wire [31:0] Instruction_ID;
    wire [5:0]  Opcode_ID;
    wire [25:0] JumpAddr_ID;
    wire [4:0] RegDst_ID;   
    wire [4:0] RegTarget_ID;
    wire [4:0] RegSource_ID;
    wire [15:0] Imm16_ID;
    
    wire [31:0] BranchTestData1;
    wire [31:0] BranchTestData2;
    wire [31:0] JumpRegResult;
    
    wire [31:0] Instruction_EX;
    wire [1:0] WriteRegSignal_EX;
    wire [1:0] WriteRegDataSignal_EX;
    wire  AluSrcASignal_EX;
    wire  AluSrcBSignal_EX; 
    wire [4:0] AluOpcode_EX;     
    wire [1:0] MemWrite_EX;     
    wire [2:0] MemRead_EX;      
    wire  RegWrite_EX;  
    wire [31:0] Imm32_EX;
    
    
    
    
    wire[31:0] ForwardAData;
    wire[31:0] ForwardBData;
    wire[31:0] ForwardCData;
    wire[31:0] ForwardDData;
    wire[31:0] ForwardEData;
    
    wire [1:0] ForwardASignal;
    wire [1:0] ForwardBSignal;
    wire [1:0] ForwardCSignal;
    wire [1:0] ForwardDSignal;
    wire [1:0] ForwardESignal;

    wire [4:0] WriteRegAddr_MEM;
    wire [4:0] WriteRegAddr_WB;
    wire [2:0] MemRead_MEM;
    wire RegWrite_MEM;    
    wire [1:0] WriteRegDataSignal_MEM;
    wire [31:0] Instruction_MEM;
    wire [2:0] WriteMemDataLength;
    wire [3:0] ReadMemExtSignal_MEM;
    wire [3:0] ReadMemExtSignal_WB;
    wire RegWrite_WB;
    wire [31:0] AluResult_WB;
    wire [1:0] WriteRegDataSignal_WB;
    wire [31:0] ReadMemData_WB;
    wire [31:0] Instruction_WB;
    wire [5:0] Func_ID;
    wire [31:0] PC_EX;
    wire [31:0] PC_MEM;
    wire [31:0] PC_WB;
    
    wire [2:0] JumpSignal_EX;
    
    
    
    assign Opcode_ID = Instruction_ID[31:26];
    assign Func_ID = Instruction_ID[5:0];
    assign JumpAddr_ID = Instruction_ID[25:0];
    assign RegDst_ID = Instruction_ID[15:11];
    assign RegTarget_ID = Instruction_ID[20:16];
    assign RegSource_ID = Instruction_ID[25:21];
    assign Shamt_ID = {27'b0,Instruction_ID[10:6]};
    
    assign RegDst = instruction[15:11];
    assign RegTarget = instruction[20:16];
    assign RegSource = instruction[25:21];
    assign Opcode = instruction[31:26];
    assign Func = instruction[5:0];
    assign Shamt = {27'b0,instruction[10:6]};
    assign Imm16_ID = Instruction_ID[15:0];
    assign JumpAddr = instruction[25:0];
    
    
    PC PC(
        .clock(clock),.reset(reset),
        .PCWrite(PCWrite),              //stop or continue get instructions
        .NextPC(NextInstAddress),       //Next Instruction's Address (from NextPC)
        .PC(InstAddress)                //Instruction's Address (transmit to IM)
    );
    
    BranchTest BPM(
        .JumpSignal(JumpSignal),
        .BranchTestData1(ForwardCData),
        .BranchTestData2(ForwardDData),
        .Opcode_IF(Opcode),
        .Opcode_ID(Opcode_ID),
        .Func_ID(RegTarget_ID),
        .NextPCSignal(NextPCSignal),
        .IF_Flush(IF_Flush)
    );
    
    NextPC NextPC(
        .NextPCSignal(NextPCSignal),
        .PC(InstAddress),
        .PC_ID(PC_ID+4),
        .JumpAddr_IF(JumpAddr),
        .JumpAddr_ID(JumpAddr_ID),
        .JumpReg(ForwardEData),
        .NextPC(NextInstAddress)
    );
    
    IF_ID AR(
        .clock(clock),
        .PCWrite(PCWrite),
        .IF_Flush(IF_Flush),
        .PC_IF(InstAddress),
        .Instruction_IF(instruction),
        .PC_ID(PC_ID),
        .Instruction_ID(Instruction_ID)
    );
    
    
    MUX2 #(32) SRC_B(.DataIn0(ForwardBData),.DataIn1(Imm32_EX),.Signal(AluSrcBSignal_EX),.DataOut(AluOperandB));
    AluSrcA SRC_A(ForwardAData,Shamt_EX,PC_EX + 4,JumpSignal_EX,AluSrcASignal_EX,AluOperandA);
    SignExtension IMM_EXT(Imm16_ID,SignExt,Imm32);
    MemDataExtension MEM_EXT(ReadMemData_WB,ReadMemExtSignal_WB,MemDataExt);
    
    ControlUnit CU(
        .Opcode(Opcode_ID),
        .Func(Func_ID),
        .Branch(RegTarget_ID),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite_ID),
        .SignExt(SignExt),
        .AluOpcode(AluOpcode),
        .JumpSignal(JumpSignal),
        .AluSrcASignal(AluSrcASignal),
        .AluSrcBSignal(AluSrcBSignal),
        .WriteRegDataSignal(WriteRegDataSignal),
        .WriteRegSignal(WriteRegSignal),
        .MemRead(MemRead)
    );
    
    ID_EX IR(
        .clock(clock),
        .stall(stall),
        .WriteRegSignal_ID(WriteRegSignal),
        .WriteRegDataSignal_ID(WriteRegDataSignal),
        .AluSrc1Signal_ID(AluSrcASignal),
        .AluSrc2Signal_ID(AluSrcBSignal),
        .AluOpcode_ID(AluOpcode),
        .MemWrite_ID(MemWrite_ID),
        .MemRead_ID(MemRead),
        .RegWrite_ID(RegWrite),
        .ReadRegData1_ID(ReadRegData1_ID),
        .ReadRegData2_ID(ReadRegData2_ID),
        .Shamt_ID(Shamt_ID),       
        .Imm32_ID(Imm32),       
        .RegSource_ID(RegSource_ID),   
        .RegTarget_ID(RegTarget_ID),   
        .RegDst_ID(RegDst_ID),      
        .Instruction_ID(Instruction_ID), 
        .PC_ID(PC_ID),
        .JumpSignal_ID(JumpSignal),          
        .ReadRegData1_EX(ReadRegData1_EX), 
        .ReadRegData2_EX(ReadRegData2_EX), 
        .Shamt_EX(Shamt_EX),               
        .Imm32_EX(Imm32_EX),                  
        .RegSource_EX(RegSource_EX),       
        .RegTarget_EX(RegTarget_EX),       
        .RegDst_EX(RegDst_EX),             
        .Instruction_EX(Instruction_EX),   
        .PC_EX(PC_EX),                     
        .WriteRegSignal_EX(WriteRegSignal_EX),
        .WriteRegDataSignal_EX(WriteRegDataSignal_EX),
        .AluSrc1Signal_EX(AluSrcASignal_EX),
        .AluSrc2Signal_EX(AluSrcBSignal_EX), 
        .AluOpcode_EX(AluOpcode_EX),     
        .MemWrite_EX(MemWrite_EX),      
        .MemRead_EX(MemRead_EX),       
        .RegWrite_EX(RegWrite_EX),
        .JumpSignal_EX(JumpSignal_EX)         
    );
    
    ALU ALU(
        .AluOperandA(AluOperandA),
        .AluOperandB(AluOperandB),
        .AluOpcode(AluOpcode_EX),
        .MemRead(MemRead_EX),
        .MemWrite(MemWrite_EX),
        .AluResult(AluResult_EX),
        .AluOverflowSignal(AluOverflowSignal),
        .WriteMemDataLength(WriteMemDataLength),
        .ReadMemExtSignal(ReadMemExtSignal)
    );
    
    Forwarding FWD(
        .JumpSignal(JumpSignal),
        .RegSource_ID(RegSource_ID),
        .RegTarget_ID(RegTarget_ID),
        .RegSource_EX(RegSource_EX),
        .RegTarget_EX(RegTarget_EX),
        .WriteRegAddr_EX(WriteRegAddr),
        .WriteRegAddr_MEM(WriteRegAddr_MEM),
        .WriteRegAddr_WB(WriteRegAddr_WB),
        .MemRead_MEM(MemRead_MEM),
        .RegWrite_EX(RegWrite_EX),
        .RegWrite_MEM(RegWrite_MEM),
        .RegWrite_WB(RegWrite_WB),
        .ForwardASignal(ForwardASignal),
        .ForwardBSignal(ForwardBSignal),
        .ForwardCSignal(ForwardCSignal),
        .ForwardDSignal(ForwardDSignal),
        .ForwardESignal(ForwardESignal)
    );
    
    HazardDetection HazardD(
        .RegSource_ID(RegSource_ID),
        .RegTarget_ID(RegTarget_ID),
        .WriteRegAddr_EX(WriteRegAddr),
        .MemRead_EX(MemRead_EX),
        .PCWrite(PCWrite),
        .stall(stall)
    );

    MUX4 #(32) FORWARD_A(
        .DataIn0(ReadRegData1_EX),
        .DataIn1(WriteRegData),
        .DataIn2(AluResult),
        .DataIn3(0),
        .Signal(ForwardASignal),
        .DataOut(ForwardAData)
    );
    MUX4 #(32) FORWARD_B(
        .DataIn0(ReadRegData2_EX),
        .DataIn1(WriteRegData),
        .DataIn2(AluResult),
        .DataIn3(0),
        .Signal(ForwardBSignal),
        .DataOut(ForwardBData)
    );
    MUX4 #(32) FORWARD_C(
        .DataIn0(ReadRegData1_ID),
        .DataIn1(AluResult_EX),
        .DataIn2(AluResult),
        .DataIn3(WriteRegData),
        .Signal(ForwardCSignal),
        .DataOut(ForwardCData)
    );
    MUX4 #(32) FORWARD_D(
        .DataIn0(ReadRegData2_ID),
        .DataIn1(AluResult_EX),
        .DataIn2(AluResult),
        .DataIn3(WriteRegData),
        .Signal(ForwardDSignal),
        .DataOut(ForwardDData)
    );
    MUX4 #(32) FORWARD_E(
        .DataIn0(ReadRegData1_ID),
        .DataIn1(WriteRegData),
        .DataIn2(AluResult_EX),
        .DataIn3(AluResult),
        .Signal(ForwardESignal),
        .DataOut(ForwardEData)
    );
    
    MUX4 #(5) WR_REG(
        .DataIn0(RegDst_EX),       //rd    R-type                                          
        .DataIn1(RegTarget_EX),    //rt    I-type                                          
        .DataIn2(5'b11111),     //no.31 register is usually the J-Type's return Address 
        .DataIn3(0),
        .Signal(WriteRegSignal_EX),                                                        
        .DataOut(WriteRegAddr)                                                          
    );
    
    MUX4 #(32) WR_REG_DATA(         //mux that write which data to register
        .DataIn0(AluResult_WB),        //R-type's result store in the rd
        .DataIn1(MemDataExt),      //load instruction's data store in the rt
        .DataIn2(PC_WB + 4),  //jalr,jal,bltzal,bgezal
        .DataIn3(0),
        .Signal(WriteRegDataSignal_WB),
        .DataOut(WriteRegData)
    );
    
    EX_MEM DR(
    .clock(clock),
    .MemRead_EX           (MemRead_EX),
    .MemWrite_EX          (MemWrite_EX),
    .RegWrite_EX          (RegWrite_EX),
    .WriteRegDataSignal_EX(WriteRegDataSignal_EX),
    .AluResult_EX         (AluResult_EX),       
    .WriteMemData_EX      (ForwardBData),           //rt: sb,sw,sh
    .WriteRegAddr_EX      (WriteRegAddr),
    .Instruction_EX       (Instruction_EX),
    .WriteMemDataLength_EX(WriteMemDataLength),
    .ReadMemExtSignal_EX  (ReadMemExtSignal),
    .PC_EX(PC_EX),
    .MemRead_MEM           (MemRead_MEM),
    .MemWrite_MEM          (MemWrite),
    .RegWrite_MEM          (RegWrite_MEM),
    .WriteRegDataSignal_MEM(WriteRegDataSignal_MEM),
    .AluResult_MEM         (AluResult),
    .WriteMemData_MEM      (WriteMemData),
    .WriteRegAddr_MEM      (WriteRegAddr_MEM),
    .Instruction_MEM       (Instruction_MEM),
    .WriteMemDataLength_MEM(WriteMemDataLength_MEM),
    .ReadMemExtSignal_MEM  (ReadMemExtSignal_MEM),
    .PC_MEM(PC_MEM)
    );
    MEM_WB WB(
        .clock(clock),
        .RegWrite_MEM          (RegWrite_MEM),
        .WriteRegDataSignal_MEM(WriteRegDataSignal_MEM),
        .ReadMemData_MEM       (ReadMemData),
        .AluResult_MEM         (AluResult),
        .WriteRegAddr_MEM      (WriteRegAddr_MEM),
        .Instruction_MEM       (Instruction_MEM),
        .ReadMemExtSignal_MEM  (ReadMemExtSignal_MEM),
        .PC_MEM(PC_MEM),
        .RegWrite_WB          (RegWrite_WB),
        .WriteRegDataSignal_WB(WriteRegDataSignal_WB),
        .ReadMemData_WB       (ReadMemData_WB),
        .AluResult_WB         (AluResult_WB),
        .WriteRegAddr_WB      (WriteRegAddr_WB),
        .Instruction_WB       (Instruction_WB),
        .ReadMemExtSignal_WB (ReadMemExtSignal_WB),
        .PC_WB(PC_WB)
    );
    
    Register RF(
        .RegWrite(RegWrite_WB),
        .ReadRegAddr1(RegSource_ID),
        .ReadRegAddr2(RegTarget_ID),
        .WriteRegAddr(WriteRegAddr_WB),        //write to which Registers                                 
        .WriteRegData(WriteRegData),        //data write to registers                                  
        .ReadRegData1(ReadRegData1_ID),               //Read Data1 rf[rs]                                
        .ReadRegData2(ReadRegData2_ID)                 //Read Data2  rd[rt]        SB,SW write to memory  
    );
    
    
endmodule
