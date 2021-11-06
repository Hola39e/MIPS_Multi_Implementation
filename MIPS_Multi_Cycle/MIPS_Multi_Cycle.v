/*

	File name    : MIPS_Multi_Cycle
	LastEditors  : H
	LastEditTime : 2021-11-01 12:54:34
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-31 13:48:53
	FilePath     : \MIPS_Multi_Cycle\MIPS_Multi_Cycle.v
	Copyright 2021 H, All Rights Reserved. 

*/
module MIPS_Multi_Cycle(
    // System Clock
    input               clk,
    input               rst_n

    // User Interface
    
);
    wire [31:0]         PC;
    wire [31:0]         ALUResult;
    wire [31:0]         SignImm;
    wire [31:0]         ALUOut;
    wire [31:0]         Instr;
    wire [31:0]         Data;
    wire [31:0]         A,B;
    wire [31:0]         Adr;
    wire [31:0]         WriteRegData;
    
    wire [2:0]          ALUControl;
    wire [1:0]          ALUOp;
    wire [1:0]          PCSrc;
    wire [4:0]          WriteReg;
    wire [1:0]          ALUSrcB;
    wire                ALUSrcA;     

    wire                MemWrite, RegWrite, IorD;
    wire                RegDst, ALUSrc, MemtoReg;
    wire                Branch, Zero;
    wire                PCEn, PCWrite, IRWrite;
    
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign PCEn         = (Branch & Zero) | PCWrite;

    assign WriteReg     = RegDst ? Instr[15:11] : Instr[20:16];
    assign WriteRegData = MemtoReg ? Data : ALUOut;

    PC_Counter u_PC_Counter(
        .clk            (clk),
        .rst_n          (rst_n),
        .PCSrc          (PCSrc),
        .PCEn           (PCEn),
        .IorD           (IorD),
        .ALUOut         (ALUOut),
        .ALUResult      (ALUResult),
        .Jump_low_26Bit (Instr[25:0]),
        .Adr            (Adr),
        .PC             (PC)
    );

    Instr_Data_Memory u_Instr_Data_Memory(
        .clk            (clk),
        .A              (Adr),
        .WD             (B),
        .IRWrite        (IRWrite),
        .MemWrite       (MemWrite),
        .Instr          (Instr),
        .Data           (Data)
    );

    Control_Unit u_Control_Unit(
        .clk            (clk),
        .rst_n          (rst_n),
        .Opcode         (Instr[31:26]),
        .ALUOp          (ALUOp),
        .MemtoReg       (MemtoReg),
        .RegDst         (RegDst),
        .IorD           (IorD),
        .PCSrc          (PCSrc),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .IRWrite        (IRWrite),
        .MemWrite       (MemWrite),
        .PCWrite        (PCWrite),
        .Branch         (Branch),
        .RegWrite       (RegWrite)
    );

    Reg_File u_Reg_File(
        .clk            (clk),
        .A1             (Instr[25:21]),
        .A2             (Instr[20:16]),
        .A3             (WriteReg),
        .A              (A),
        .B              (B),
        .RegWrite       (RegWrite),
        .WD3            (WriteRegData)
    );

    Imm_Sign_Extend u_Imm_Sign_Extend(
        .Immediate      (Instr[15:0]),
        .SignImm        (SignImm)
    );


    ALU_Control_Unit u_ALU_Control_Unit(
        .Funct          (Instr[5:0]),
        .ALUOp          (ALUOp),
        .ALUControl     (ALUControl)
    );

    ALU u_ALU(
        .clk            (clk),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .ALUControl     (ALUControl),
        .A              (A),
        .B              (B),
        .PC             (PC),
        .SignImm        (SignImm),
        .ALUOut         (ALUOut),
        .ALUResult      (ALUResult),
        .Zero           (Zero)
    );

endmodule