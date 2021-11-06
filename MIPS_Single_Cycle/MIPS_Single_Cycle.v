/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 17:29:07
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 17:29:00
	FilePath     : \MIPS_Single\MIPS_Single_Cycle.v
	Copyright 2021 H, All Rights Reserved. 

*/
module MIPS_Single_Cycle(
    // System Clock
    input        clk,
    input        rst_n

    // User Interface
    
);
    wire [31:0]     PC;
    wire [31:0]     Instr,ALUResult;
    wire [31:0]     ReadData,WriteData;
    wire [31:0]     SrcA,SrcB;
    wire            MemWrite,RegWrite;

    wire            RegDst,ALUSrc,MemtoReg;

    wire [4:0]      WriteReg;
    wire [31:0]     SignImm,RD2;
    wire [31:0]     WD3;

    wire            PCSrc,Branch,Zero;
    wire            Jump;

    wire [2:0]      ALUControl;
    wire [1:0]      ALUOp;


    assign PCSrc        = Branch & Zero;
    assign WriteReg     = RegDst ? Instr[15:11] : Instr[20:16];
    assign SrcB         = ALUSrc ? SignImm : RD2;
    assign WD3          = MemtoReg ? ReadData : ALUResult;
    assign WriteData    = RD2;

    PC_Counter u_PC_Counter(
        .clk(clk),
        .rst_n(rst_n),
        .PC(PC),
        .PCSrc(PCSrc),
        .Jump(Jump),
        .Jump_low_26Bit(Instr[25:0]),
        .SignImm(SignImm)
    );

    Instr_Memory u_Instr_Memory(
        .RD(Instr),
        .A(PC)
    );

    Control_Unit u_Control_Unit(
        .clk(clk),
        .rst_n(rst_n),
        .Opcode(Instr[31:26]),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .Branch(Branch)
    );

    Reg_File u_Reg_File(
        .clk(clk),
        .A1(Instr[25:21]),
        .RD1(SrcA),
        .A2(Instr[20:16]),
        .RD2(RD2),
        .A3(WriteReg),
        .RegWrite(RegWrite),
        .WD3(WD3)
    );

    Imm_Sign_Extend u_Imm_Sign_Extend(
        .Immediate(Instr[15:0]),
        .SignImm(SignImm)
    );

    Data_Memory u_Data_Memory(
        .clk(clk),
        .rst_n(rst_n),

        .A(ALUResult),
        .RD(ReadData),
        .WE(MemWrite),
        .WD(WriteData)
    );

    ALU_Control_Unit u_ALU_Control_Unit(
        .Funct(Instr[5:0]),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    ALU u_ALU(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

endmodule