/*

	File name    : PC_Counter
	LastEditors  : H
	LastEditTime : 2021-11-04 21:42:50
	Last Version : 1.0
	Description  : Programm Instrcutions Counter
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\PC_Counter.v
	Copyright 2021 H, All Rights Reserved. 

*/
module PC_Counter(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input                   PCSrcD,
    input                   StallF,
    input           [31:0]  PCBranchD,
    input                   JumpD,
    input           [25:0]  InstrD_Low25Bit,
    output          [31:0]  PCPlus4F,
    output   reg    [31:0]  PC
);

    wire    [31:0] PC_Next,PC_Next_or_Jump,PC_Jump;
    wire    [31:0] PCPlus4;
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    
    assign  PC_Next = PCSrcD ? PCBranchD : PCPlus4F;
    assign  PC_Jump = {{PCPlus4F[31:28]},{InstrD_Low25Bit},{2'b00}};
    assign  PCPlus4 = PC + 32'd4;
    assign  PCPlus4F = PCPlus4;
    assign  PC_Next_or_Jump = JumpD ? PC_Jump : PC_Next;


    always @(posedge clk) begin
        if(~rst_n)begin
            PC <= 32'b0;
        end
        else if (StallF) begin
            PC <= PC;
        end
        else 
            PC <= PC_Next_or_Jump;
    end

endmodule