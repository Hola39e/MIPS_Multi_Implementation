/*

	File name    : Instr_Data_Memory
	LastEditors  : H
	LastEditTime : 2021-11-01 11:10:05
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-31 13:48:53
	FilePath     : \MIPS_Multi_Cycle\Instr_Data_Memory.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Instr_Data_Memory(
    // System Clock
	input				clk,
    input   	[31:0]	A,
	input		[31:0]	WD,
	input				IRWrite,
	input				MemWrite,

	output	reg	[31:0]	Instr,
	output	reg	[31:0]	Data
    // User Interface
    
);
	integer fd;
	wire [31:0] RD;
	reg [7:0] Instr_Data_Mem [84:0];

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

	initial begin
		$readmemh("./memfile.dat",Instr_Data_Mem,0,71);
		fd = $fopen("./MEM_Data.txt", "w");  
        #1400
        $fclose(fd);
	end

    assign RD = {{Instr_Data_Mem[A]},{Instr_Data_Mem[A+32'd1]},{Instr_Data_Mem[A+32'd2]},{Instr_Data_Mem[A+32'd3]}};

	always @(posedge clk) begin
		Data <= RD;
		if (IRWrite) begin
			Instr <= RD;
		end
		// Notice : the signal A now is Data Address here
		if (MemWrite) begin
			{{Instr_Data_Mem[A]},{Instr_Data_Mem[A+32'd1]},{Instr_Data_Mem[A+32'd2]},{Instr_Data_Mem[A+32'd3]}} <= WD;
			$fdisplay(fd,"The Write Address A is %h", A);
            $fdisplay(fd,"DATA_MEM[A] is %h", WD);
		end
	end
endmodule