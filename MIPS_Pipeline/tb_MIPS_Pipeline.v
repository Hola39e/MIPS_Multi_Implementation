/*

	File name    : tb_MIPS_Pipeline
	LastEditors  : H
	LastEditTime : 2021-11-04 21:43:18
	Last Version : 1.0
	Description  : testbench of MIPS_Pipeline
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-11-04 21:33:08
	FilePath     : \MIPS_Pipeline\tb_MIPS_Pipeline.v
	Copyright 2021 H, All Rights Reserved. 

*/

`timescale 1ps/1ps
module tb_MIPS_Pipeline();

reg clk,rst_n;
reg [31:0] cnt;

initial
begin            
    $dumpfile("MIPS_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_MIPS_Pipeline);    //tb模块名称
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
    if (cnt >= 25) begin
        $stop;
    end
end


MIPS_Pipeline u_MIPS_Pipeline(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule