/*

	File name    : MIPS_Pipeline
	LastEditors  : H
	LastEditTime : 2021-10-28 17:29:07
	Last Version : 1.0
	Description  : Top level of MIPS 5-Stage Pipeline
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 17:29:00
	FilePath     : \MIPS_Pipeline\MIPS_Pipeline.v
	Copyright 2021 H, All Rights Reserved. 

*/
module MIPS_Pipeline(
    // System Clock
    input           clk,
    input           rst_n
);
    // Control Unit Signal
    wire            RegWrite,RegWriteE,RegWriteM,RegWriteW;
    wire            MemtoReg,MemtoRegE,MemtoRegM,MemtoRegW;
    wire            MemWrite,MemWriteE,MemWriteM;
    wire [2:0]      ALUControl,ALUControlE;
    wire            BranchD,JumpD;
    wire            ALUSrc,ALUSrcE;
    wire            RegDst,RegDstE;
    // Harzard Control Unit Signal
    wire            FlushE,StallD,StalF;
    wire [1:0]      ForwardAE,ForwardBE;
    wire            ForwardAD,ForwardBD;
    // Pipeline Stage Signal
    wire            PCSrcD,ZeroM;
    wire [1:0]      ALUOp,ALUOpE;
    wire [4:0]      RtE,RdE,RsE;
    wire [4:0]      WriteRegE,WriteRegM,WriteRegW;
    wire [31:0]     PC,PCBranchD;
    wire [31:0]     ALUOut,ALUOutM,ALUOutW,WriteDataM;
    wire [31:0]     ReadDataW,ResultW,ReadDataM;
    wire [31:0]     SignImm,SignImmE,RD1E,RD2E,SrcB_Forward;
    wire [31:0]     Instr,InstrD,PCPlus4D,PCPlus4F,RD1,RD2;
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign ResultW          = MemtoRegW ? ReadDataW : ALUOutW;
    assign WriteRegE        = RegDstE ? RdE : RtE;

    PC_Counter u_PC_Counter(
        .clk(clk),
        .rst_n(rst_n),
        .PCSrcD(PCSrcD),
        .PCBranchD(PCBranchD),
        .PCPlus4F(PCPlus4F),
        .StallF(StallF),
        .JumpD(JumpD),
        .InstrD_Low25Bit(InstrD[25:0]),
        .PC(PC)
    );

    Instr_Memory u_Instr_Memory(
        .RD(Instr),
        .A(PC)
    );

    IF_ID_Register u_IF_ID_Register(
        .clk(clk),
        .rst_n(rst_n),
        .PCPlus4F(PCPlus4F),
        .Instr(Instr),
        .PCPlus4D(PCPlus4D),
        .StallD(StallD),
        .PCSrcD(PCSrcD),
        .JumpD(JumpD),
        .InstrD(InstrD)
    );

    Control_Unit u_Control_Unit(
        .rst_n(rst_n),
        .Opcode(InstrD[31:26]),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .Jump(JumpD),
        .Branch(BranchD)
    );

    Reg_File u_Reg_File(
        .clk(clk),
        .rst_n(rst_n),
        .A1(InstrD[25:21]),
        .A2(InstrD[20:16]),
        .RD1(RD1),
        .RD2(RD2),
        .A3(WriteRegW),
        .RegWrite(RegWriteW),
        .WD3(ResultW)
    );

    Imm_Sign_Extend u_Imm_Sign_Extend(
        .Immediate(InstrD[15:0]),
        .SignImm(SignImm)
    );

    ID_EX_Register u_ID_EX_Register(
        .clk(clk),
        .rst_n(rst_n),
        .RD1(RD1),
        .RD2(RD2),
        .Rs(InstrD[25:21]),
        .Rt(InstrD[20:16]),
        .Rd(InstrD[15:11]),
        .SignImm(SignImm),
        .PCPlus4D(PCPlus4D),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RtE(RtE),
        .RsE(RsE),
        .RdE(RdE),
        .SignImmE(SignImmE),

        .RegWriteD(RegWrite),
        .MemtoRegD(MemtoReg),
        .MemWriteD(MemWrite),
        .RegDstD(RegDst),
        .ALUSrcD(ALUSrc),
        .FlushE(FlushE),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .RegDstE(RegDstE),
        .ALUSrcE(ALUSrcE),
        .ALUControlD(ALUControl),
        .ALUControlE(ALUControlE)
    );

    ALU u_ALU(
        .rst_n(rst_n),
        .SignImm(SignImmE),
        .ALUControl(ALUControlE),
        .ALUSrc(ALUSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ResultW(ResultW),
        .ALUOutM(ALUOutM),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .SrcB_Forward(SrcB_Forward),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );

    ALU_Control_Unit u_ALU_Control_Unit(
        .Funct(InstrD[5:0]),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );


    EX_MEM_Register u_EX_MEM_Register(
        .clk(clk),
        .rst_n(rst_n),
        .ALUOut(ALUOut),
        .WriteDataE(SrcB_Forward),
        .WriteRegE(WriteRegE),
        .Zero(Zero),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .WriteRegM(WriteRegM),
        .ZeroM(ZeroM),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .MemWriteM(MemWriteM)
    );

    Data_Memory u_Data_Memory(
        .clk(clk),
        .rst_n(rst_n),

        .A(ALUOutM),
        .RD(ReadDataM),
        .WE(MemWriteM),
        .WD(WriteDataM)
    );

    MEM_WB_Register u_MEM_WB_Register(
        .clk(clk),
        .rst_n(rst_n),

        .ReadDataM(ReadDataM),
        .ALUOutM(ALUOutM),
        .WriteRegM(WriteRegM),
        .ReadDataW(ReadDataW),
        .ALUOutW(ALUOutW),
        .WriteRegW(WriteRegW),

        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW)
    );

    Forward_Unit u_Forward_Unit(
        .rst_n(rst_n),
        .RsE(RsE),
        .RtE(RtE),
        .RsD(InstrD[25:21]),
        .RtD(InstrD[20:16]),
        .WriteRegM(WriteRegM),
        .WriteRegW(WriteRegW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD)
    );

    Stall_Unit u_Stall_Unit(
        .clk(clk),
        .rst_n(rst_n),
        .RsD(InstrD[25:21]),
        .RtD(InstrD[20:16]),
        .RtE(RtE),
        .WriteRegE(WriteRegE),
        .WriteRegM(WriteRegM),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemtoRegM(MemtoRegM),
        .BranchD(BranchD),
        .FlushE(FlushE),
        .StallD(StallD),
        .StallF(StallF)
    );

    Branch_Unit u_Branch_Unit(
        .BranchD(BranchD),
        .SignImm(SignImm),
        .PCPlus4D(PCPlus4D),
        .RD1(RD1),
        .RD2(RD2),
        .ALUOutM(ALUOutM),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .PCBranchD(PCBranchD),
        .PCSrcD(PCSrcD)
    );

endmodule