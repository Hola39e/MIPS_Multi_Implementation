/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 16:51:26
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 16:51:11
	FilePath     : \MIPS_Single\Imm_Sign_Extend.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Imm_Sign_Extend(
    // System Clock

    // User Interface
    input       [15:0]  Immediate,

    output      [31:0]  SignImm
);
    assign  SignImm = {{16{Immediate[15]}}, Immediate[15:0]};
endmodule