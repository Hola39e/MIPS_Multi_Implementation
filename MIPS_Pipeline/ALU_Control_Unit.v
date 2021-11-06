/*

	File name    : ALU_Control_Unit
	LastEditors  : H
	LastEditTime : 2021-11-04 21:33:54
	Last Version : 1.0
	Description  : Control the ALU Unit to run specific operation. Output the Signal Alucontrol
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\ALU_Control_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/

module ALU_Control_Unit(
    // System Clock

    // User Interface
    input       [5:0]   Funct,
    input       [1:0]   ALUOp,
    output  reg [2:0]   ALUControl
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010;
            2'b10: begin
                case (Funct)
                    6'b100000 : ALUControl = 3'b010;
                    6'b100010 : ALUControl = 3'b110;
                    6'b100100 : ALUControl = 3'b000;
                    6'b100101 : ALUControl = 3'b001;
                    6'b101010 : ALUControl = 3'b111;
                endcase
            end
            2'b01: ALUControl = 3'b110;
            default: ;
        endcase
    end


endmodule