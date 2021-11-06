/*

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-28 20:59:03
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-28 20:59:02
	FilePath     : \MIPS_Single\Control_Unit.v
	Copyright 2021 H, All Rights Reserved. 

*/
module Control_Unit(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface

    input       [5:0]   Opcode,

    output  reg [1:0]   ALUOp,
    output  reg         MemtoReg,
    output  reg         RegDst,
    output  reg         IorD,
    output  reg [1:0]   PCSrc,
    output  reg [1:0]   ALUSrcB,
    output  reg         ALUSrcA,

    output  reg         IRWrite,
    output  reg         MemWrite,
    output  reg         PCWrite,
    output  reg         Branch,
    output  reg         RegWrite
);

    parameter   S0_Fetch   = 4'd0, S1_Decode       = 4'd1, S2_MemAdr   = 4'd2;
    parameter   S3_MemRead = 4'd3, S4_MemWriteback = 4'd4, S5_MemWrite = 4'd5;
    parameter   S6_Execute = 4'd6, S7_ALU_Writeback= 4'd7, S8_Branch   = 4'd8;
    parameter   S9_ADDI    = 4'd9, S10_ADDI_Writeback=4'd10,S11_Jump   = 4'd11;
    reg [3:0]   Current_State, Next_State;  

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(*) begin
        case(Current_State)
            S0_Fetch : begin
                IorD    = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b00;
                PCSrc   = 2'b00;


                IRWrite = 1'b1;
                MemWrite= 1'b0;
                PCWrite = 1'b1;
                Branch  = 1'b0;
                RegWrite= 1'b0;
            end
            S1_Decode : begin
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b11;
                ALUOp   = 2'b00;

                IRWrite = 1'b0;
                MemWrite= 1'b0;
                PCWrite = 1'b0;
                Branch  = 1'b0;
                RegWrite= 1'b0;
            end
            S2_MemAdr : begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b10;
                ALUOp   = 2'b00;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            S3_MemRead : begin
                IorD     = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            S4_MemWriteback : begin
                RegDst   = 1'b0;
                MemtoReg = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            S5_MemWrite : begin
                IorD     = 1'b1;

                IRWrite  = 1'b0;
                MemWrite = 1'b1;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            S6_Execute : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b00;
                ALUOp    = 2'b10;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            S7_ALU_Writeback : begin
                RegDst   = 1'b1;
                MemtoReg = 1'b0;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            S8_Branch : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b00;
                ALUOp    = 2'b01;
                PCSrc    = 2'b01; 

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b1;
                RegWrite = 1'b0;
            end
            S9_ADDI : begin
                ALUSrcA  = 1'b1;
                ALUSrcB  = 2'b10;
                ALUOp    = 2'b00;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
            S10_ADDI_Writeback : begin
                RegDst   = 1'b0;
                MemtoReg = 1'b0;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b0;
                Branch   = 1'b0;
                RegWrite = 1'b1;
            end
            S11_Jump : begin
                PCSrc    = 2'b10;

                IRWrite  = 1'b0;
                MemWrite = 1'b0;
                PCWrite  = 1'b1;
                Branch   = 1'b0;
                RegWrite = 1'b0;
            end
        endcase 
    end

    always @(*) begin
        case(Current_State)
            S0_Fetch : Next_State = S1_Decode;
            S1_Decode : begin
                case(Opcode)
                    // OP = lw or sw
                    6'b100011,6'b101011 : Next_State = S2_MemAdr;
                    // Op = R-type
                    6'b000000: Next_State = S6_Execute;
                    // Op = Beq
                    6'b000100: Next_State = S8_Branch;
                    // Op = addi
                    6'b001000: Next_State = S9_ADDI;
                    // Op = Jump
                    6'b000010: Next_State = S11_Jump;
                endcase 
            end
            S2_MemAdr : begin
                case (Opcode)
                    6'b100011: Next_State = S3_MemRead;
                    6'b101011: Next_State = S5_MemWrite;
                    
                    default: ;
                endcase
            end
            S3_MemRead      : Next_State = S4_MemWriteback;
            S4_MemWriteback : Next_State = S0_Fetch;
            S5_MemWrite     : Next_State = S0_Fetch;
            S6_Execute      : Next_State = S7_ALU_Writeback;
            S7_ALU_Writeback: Next_State = S0_Fetch;
            S8_Branch       : Next_State = S0_Fetch;
            S9_ADDI         : Next_State = S10_ADDI_Writeback;
            S10_ADDI_Writeback : Next_State = S0_Fetch;
            S11_Jump        : Next_State = S0_Fetch;
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            Current_State <= S0_Fetch;
        end
        else begin
            Current_State <= Next_State;
        end
    end

endmodule