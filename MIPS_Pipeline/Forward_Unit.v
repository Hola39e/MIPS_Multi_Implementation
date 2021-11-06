/*

	File name    : Forward_Unit
	LastEditors  : H
	LastEditTime : 2021-11-04 01:08:44
	Last Version : 1.0
	Description  : Handle data hazard (Bypass)
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-04 01:08:42
	FilePath     : \MIPS_Pipeline\Forward_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Forward_Unit(
    // System Clock
    input        rst_n,

    // User Interface
    input       [4:0]   RsE,
    input       [4:0]   RtE,
    input       [4:0]   RsD,
    input       [4:0]   RtD,
    input       [4:0]   WriteRegM,
    input       [4:0]   WriteRegW,
    input               RegWriteM,
    input               RegWriteW,

    output  reg [1:0]   ForwardAE,
    output  reg [1:0]   ForwardBE,
    output  reg         ForwardAD,
    output  reg         ForwardBD
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(*) begin
        if (~rst_n) begin
            ForwardAE = 2'b00;
        end
        else begin
            // RsE != Reg0 ($0) : no need to use bypass when RsE is $0
            // RsE == WriteRegM : the hazard is happened in EX/MEM.RegisterRd = ID/EX.RegisterRs
            if ((RsE != 0) && (RsE == WriteRegM) && RegWriteM) begin
                // the first ALU Operand come from last ALU calculate result
                ForwardAE = 2'b10;
            end
            // RsE == WriteRegW : the hazard is happened in MEM/WB.RegisterRd = ID/EX.RegisterRs
            else if ((RsE != 0) && (RsE == WriteRegW) && RegWriteW) begin
                // the first ALU Operand come from last ALU calculate result or Memory data
                ForwardAE = 2'b01;
            end
            else
                ForwardAE = 2'b00;
        end
    end

    always @(*) begin
        if (~rst_n) begin
            ForwardBE = 2'b00;
        end
        else begin
            // RtE != Reg0 ($0) : no need to use bypass when RtE is $0
            // RtE == WriteRegM : the hazard is happened in EX/MEM.RegisterRd = ID/EX.RegisterRt
            if ((RtE != 0) && (RtE == WriteRegM) && RegWriteM) begin
                // the first ALU Operand come from last ALU calculate result
                ForwardBE = 2'b10;
            end
            // RtE == WriteRegW : the hazard is happened in MEM/WB.RegisterRd = ID/EX.RegisterRt
            else if ((RtE != 0) && (RtE == WriteRegW) && RegWriteW) begin
                // the first ALU Operand come from last ALU calculate result or Memory data
                ForwardBE = 2'b01;
            end
            else
                ForwardBE = 2'b00;
        end
    end
    // RegWriteM && (WriteRegM != 0) && (WriteRegM != RsE)

    always @(*) begin
        if (~rst_n) begin
            ForwardAD = 1'b0;
        end
        else if ((RsD != 0) && (RsD == WriteRegM) && RegWriteM) begin
            ForwardAD = 1'b1;
        end
        else begin
            ForwardAD = 1'b0;
        end
    end

    always @(*) begin
        if (~rst_n) begin
            ForwardBD = 1'b0;
        end
        else if ((RtD != 0) && (RtD == WriteRegM) && RegWriteM) begin
            ForwardBD = 1'b1;
        end
        else begin
            ForwardBD = 1'b0;
        end
    end

    // addi Hazard: EX/MEM.RegisterRd = 
endmodule