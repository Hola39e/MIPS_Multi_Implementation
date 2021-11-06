/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 16:37:57
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 16:37:55
	FilePath     : \MIPS_Single\Reg_File.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Reg_File (
    input               clk,
    input       [4:0]   A1,
    input       [4:0]   A2,
    input       [4:0]   A3,

    input               RegWrite,
    input       [31:0]  WD3,
    output      [31:0]  RD2,
    output      [31:0]  RD1

);
    // lw : load word instr [op(6bit) rs(5bit) rd(5bit) imm(16bit)]

    reg [31:0]  ROM [31:0];
    initial begin
        ROM[0] <= 32'b0;
        ROM[1] <= 32'b0;
        ROM[2] <= 32'b0;
        ROM[3] <= 32'b0;
        ROM[4] <= 32'b0;
        ROM[5] <= 32'b0;
        ROM[6] <= 32'b0;
        ROM[7] <= 32'b0;
        ROM[8] <= 32'b0;
        ROM[9] <= 32'b0;
        ROM[10] <= 32'b0;
        ROM[11] <= 32'b0;
        ROM[12] <= 32'b0;
        ROM[13] <= 32'b0;
        ROM[14] <= 32'b0;
        ROM[15] <= 32'b0;
    end


    assign RD1 = ROM[A1];
    assign RD2 = ROM[A2];
    // RegWrite is set to 1 when lw Instr is executed
    always @(posedge clk) begin
        if (RegWrite) begin
            // load word
            ROM[A3] <= WD3;
        end
    end
endmodule