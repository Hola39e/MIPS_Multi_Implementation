/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 21:36:58
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 21:36:57
	FilePath     : \MIPS_Single\PC_Counter.v
	Copyright 2021 H, All Rights Reserved. 

*/
module PC_Counter(
    // System Clock
    input                       clk,
    input                       rst_n,

    // User Interface
    input                       PCEn,
    input                       IorD,   // Instruction or Data
    input               [1:0]   PCSrc,
    input               [25:0]  Jump_low_26Bit,
    input               [31:0]  ALUOut,
    input               [31:0]  ALUResult,
    output              [31:0]  Adr,
    output  reg         [31:0]  PC
);
    reg                 [31:0]  PC_Next;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign Adr = IorD ? ALUOut : PC;
    // MIPS Multi Cycle: Use ALU to Calculate the PC + 4
    always @(*) begin
        case(PCSrc)
            2'b00: PC_Next = ALUResult;
            2'b01: PC_Next = ALUOut;
            2'b10: PC_Next = {{PC[31:28]}, {Jump_low_26Bit}, 2'b00};
        endcase
    end

    always @(posedge clk) begin
        if(~rst_n)begin
            PC <= 32'b0;
        end
        else if (PCEn) begin
            // here PC_Next need to change
            PC <= PC_Next;
        end
    end

endmodule