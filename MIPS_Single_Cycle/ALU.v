/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 16:44:49
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 16:44:48
	FilePath     : \MIPS_Single\ALU.v
	Copyright 2021 H, All Rights Reserved. 

*/
module ALU(
    // System Clock

    // User Interface
    input       [31:0]  SrcA,
    input       [31:0]  SrcB,
    input       [2:0]   ALUControl,
    output  reg [31:0]  ALUResult,
    output              Zero
);

    always @(*) begin
        case (ALUControl)
            3'b010 : begin
                ALUResult = SrcA + SrcB;
            end 
            3'b110 : begin
                ALUResult = SrcA - SrcB;
            end
            3'b000 : ALUResult = SrcA & SrcB;
            3'b001 : ALUResult = SrcA | SrcB;
            3'b111 : ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0;
            default: ;
        endcase
    end

    assign Zero = (ALUResult) ? 1'b0 : 1'b1;

endmodule