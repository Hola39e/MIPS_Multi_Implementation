/*

	File name    : IF_ID_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:02:04
	Last Version : 1.0
	Description  : Pipeline Stage Register : IF/ID
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:02:03
	FilePath     : \MIPS_Pipeline\IF_ID_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module IF_ID_Register(
    // System Clock
    input        clk,
    input        rst_n,

    input               StallD,
    input               PCSrcD,
    input               JumpD,
    // User Interface
    input       [31:0]  PCPlus4F,
    input       [31:0]  Instr,

    output  reg [31:0]  PCPlus4D,
    output  reg [31:0]  InstrD
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge clk ) begin
        if (~rst_n) begin
            PCPlus4D <= 32'b0;
            InstrD <= 32'b0;
        end
        else if (PCSrcD || JumpD) begin
            InstrD <= 32'b0;
            PCPlus4D <= 32'b0;
        end
        else if (StallD) begin
            PCPlus4D <= PCPlus4D;
            InstrD   <= InstrD;
        end
        else begin
            // total 64bits
            PCPlus4D <= PCPlus4F;
            InstrD   <= Instr;
        end
    end

endmodule