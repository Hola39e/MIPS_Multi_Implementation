/*

	File name    : Imm_Sign_Extend
	LastEditors  : H
	LastEditTime : 2021-11-04 21:50:55
	Last Version : 1.0
	Description  : According to Sign bit, Extend Imm to 32bits
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-03 21:01:39
	FilePath     : \MIPS_Pipeline\Imm_Sign_Extend.v
	Copyright 2021 H, All Rights Reserved. 

*/

module Imm_Sign_Extend(
    // User Interface
    input       [15:0]  Immediate,

    output      [31:0]  SignImm
);
    assign  SignImm = {{16{Immediate[15]}}, Immediate[15:0]};
endmodule