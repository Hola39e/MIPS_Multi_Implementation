/*

	File name    : Control_Unit
	LastEditors  : H
	LastEditTime : 2021-11-04 21:48:09
	Last Version : 1.0
	Description  : According to Opcode Output the Control Signal
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\Control_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Control_Unit(
    // System Clock
    input        rst_n,
    // User Interface
    output  reg [1:0]    ALUOp,
    output  reg     MemWrite,RegWrite,
    output  reg     RegDst,
    output  reg     MemtoReg,
    output  reg     ALUSrc,
    output  reg     Branch,
    output  reg     Jump,
    input   [5:0]   Opcode
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

always @(*) begin
    if (rst_n) begin
        RegWrite = 1'b0;
        RegDst   = 1'b0;
        ALUSrc   = 1'b0;
        Branch   = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        ALUOp    = 2'b00;
        Jump     = 1'b0;
    end
    case (Opcode)
        // R type no Immediate Instruction
        6'b000000 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b1;
            ALUSrc   = 1'b0;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b10;
            Jump     = 1'b0;
        end
        // beq Instruction
        6'b000100 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;    // dont care
            ALUSrc   = 1'b0;
            Branch   = 1'b1;    
            MemWrite = 1'b0;
            MemtoReg = 1'b0;    // dont care
            ALUOp    = 2'b01;
            Jump     = 1'b0;
        end
        // sw Instruction
        6'b101011 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b1;
            MemtoReg = 1'b1;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // lw Instruction
        6'b100011 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b1;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // addi Instruction
        6'b001000 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b0;
            ALUSrc   = 1'b1;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
        // J type Instruction
        6'b000010 : begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;
            ALUSrc   = 1'b0;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b00;
            Jump     = 1'b1;
        end
        default: begin
            RegWrite = 1'b0;
            RegDst   = 1'b0;
            ALUSrc   = 1'b0;
            Branch   = 1'b0;
            MemWrite = 1'b0;
            MemtoReg = 1'b0;
            ALUOp    = 2'b00;
            Jump     = 1'b0;
        end
    endcase
end

endmodule