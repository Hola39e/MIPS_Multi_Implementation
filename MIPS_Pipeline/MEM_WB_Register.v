/*

	File name    : MEM_WB_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:11:19
	Last Version : 1.0
	Description  : Pipeline Stage Register : MEM/WB
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:11:18
	FilePath     : \MIPS_Pipeline\MEM_WB_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module MEM_WB_Register(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       [31:0]  ReadDataM,
    input       [31:0]  ALUOutM,
    input       [4:0]   WriteRegM, 

    output  reg [31:0]  ReadDataW,
    output  reg [31:0]  ALUOutW,
    output  reg [4:0]   WriteRegW,

    // Control Signal 
    input               RegWriteM,
    input               MemtoRegM,
    // WB
    output  reg         RegWriteW,
    output  reg         MemtoRegW
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            RegWriteW <= 1'b0;
            MemtoRegW <= 1'b0;
        end
        else begin
            // total 64bits
            ReadDataW <= ReadDataM;
            ALUOutW   <= ALUOutM;
            WriteRegW <= WriteRegM;

            // Control Unit
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
        end
    end

endmodule