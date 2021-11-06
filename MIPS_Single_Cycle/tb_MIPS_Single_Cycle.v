/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 18:52:26
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 18:52:16
	FilePath     : \MIPS_Single\tb_MIPS_Single_Cycle.v
	Copyright 2021 H, All Rights Reserved. 

*/
`timescale 1ps/1ps
module tb_MIPS_Single_Cycle();

reg clk,rst_n;
reg [31:0] cnt;

initial
begin            
    $dumpfile("MIPS_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_MIPS_Single_Cycle);    //tb模块名称
end

initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;
    cnt <= 32'b0;

    #10
    clk <= 1'b1;

    #10
    clk <= 1'b0;
    rst_n <= 1'b1;

    forever begin
        #10 clk <= ~clk;
    end

end

always @(negedge clk) begin
    cnt <= cnt + 1'b1;
    if (cnt >= 17) begin
        $stop;
    end
end


MIPS_Single_Cycle u_MIPS_Single_Cycle(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule