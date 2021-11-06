/*

	File name    : ID_EX_Register
	LastEditors  : H
	LastEditTime : 2021-11-03 21:05:45
	Last Version : 1.0
	Description  : Pipeline Stage Register : ID/EX
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:05:43
	FilePath     : \MIPS_Pipeline\ID_EX_Register.v
	Copyright 2021 H, All Rights Reserved. 

*/
module ID_EX_Register(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       [31:0]  RD1,
    input       [31:0]  RD2,
    input       [4:0]   Rt,
    input       [4:0]   Rs,
    input       [4:0]   Rd,
    input       [31:0]  SignImm,
    input       [31:0]  PCPlus4D,

    output  reg [31:0]  RD1E,
    output  reg [31:0]  RD2E,
    output  reg [4:0]   RtE,
    output  reg [4:0]   RsE,
    output  reg [4:0]   RdE,
    output  reg [31:0]  SignImmE,
    output  reg [31:0]  PCPlus4E,

    // Control Unit Input
    input               RegWriteD,
    input               MemtoRegD,
    input               MemWriteD,
    input               RegDstD,
    input               ALUSrcD,

    input               FlushE,
    input       [2:0]   ALUControlD,
    // WB 
    output  reg         RegWriteE,
    output  reg         MemtoRegE,
    // MEM
    output  reg         MemWriteE,
    // EX
    output  reg         RegDstE,
    output  reg         ALUSrcE,
    output  reg [2:0]   ALUControlE
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            RegWriteE   <=  1'b0;
            MemtoRegE   <=  1'b0;
            MemWriteE   <=  1'b0;
            RegDstE     <=  1'b0;
            ALUSrcE     <=  1'b0;
            ALUControlE <= 3'b000;
        end
        else if (FlushE) begin
            RegWriteE   <=  1'b0;
            MemtoRegE   <=  1'b0;
        end
        else begin
            // total 128bits
            RD1E        <= RD1;
            RD2E        <= RD2;
            RtE         <= Rt;
            RsE         <= Rs;
            RdE         <= Rd;
            SignImmE    <= SignImm;
            PCPlus4E    <= PCPlus4D;

            // Control Unit Signal
            RegWriteE   <=  RegWriteD;
            MemtoRegE   <=  MemtoRegD;
            MemWriteE   <=  MemWriteD;
            RegDstE     <=  RegDstD;
            ALUSrcE     <=  ALUSrcD;
            ALUControlE <=  ALUControlD;
        end
    end

endmodule
