
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_base.v"

module decodeprinter(
	input wire       clk,
	input wire[31:0] inst
);
	// Whether this opcode is recognised by base RV32I.
	wire op_valid;
	
	// Operation will read from memory.
	wire op_will_read;
	// Operation will write to memory.
	wire op_will_write;
	// Operation will use ALU.
	wire op_uses_alu;
	// Operation is execution flow control.
	wire op_does_flowctl;
	
	// Operation equals `ECALL`.
	wire op_is_ecall;
	// Operation equals `EBREAK`.
	wire op_is_ebreak;
	
	// Operation must use 32 bits instead of XLEN (64 / 128).
	wire op_32bit;
	
	// ALU is OP-IMM* type.
	wire       op_is_imm;
	
	// Embedded immediate value, if any.
	wire[31:0] imm;
	
	// Instruction stores to `rd`.
	wire       rd_we;
	// Instruction uses value of `rs1`.
	wire       rs1_re;
	// Instruction uses values of both `rs1` and `rs2`.
	wire       rs2_re;
	
	// Destination register, if any.
	wire[4:0]  rd;
	// First source register, if any.
	wire[4:0]  rs1;
	// Second source register, if any.
	wire[4:0]  rs2;
	
	axo32_decoder decd(
		inst,
		op_valid,
		op_will_read,
		op_will_write,
		op_uses_alu,
		op_does_flowctl,
		op_is_ecall,
		op_is_ebreak,
		op_32bit,
		op_is_imm,
		imm,
		rd_we,
		rs1_re,
		rs2_re,
		rd,
		rs1,
		rs2
	);
	
	always @(posedge clk) begin
		$strobe("Analisys of instruction %08h:", inst);
		$strobe("\tValid:      %h", op_valid);
		$strobe("\tMem. read:  %h  Mem. write: %h", op_will_read, op_will_write);
		$strobe("\tALU:        %h", op_uses_alu);
		$strobe("\tFlowctl:    %h", op_does_flowctl);
		$strobe("\tHas imm:    %h  Imm:        %08h", op_is_imm, imm);
		$strobe("\tHas rd:     %h  rd:         %0d", rd_we, rd);
		$strobe("\tHas rs1:    %h  rs1:        %0d", rs1_re, rs1);
		$strobe("\tHas rs2:    %h  rs2:        %0d", rs2_re, rs2);
		$strobe();
	end
endmodule

module top(
);
	reg clk;
	reg[31:0] inst;
	
	decodeprinter _(
		clk, inst
	);
	
	initial begin
		$strobe("addi x3, x0, 2");
		#10 inst = 'h00200193;
		#10 clk  = 1;
		#10 clk  = 0;
		
		$strobe("slli x2, x2, 2");
		#10 inst = 'h00209093;
		#10 clk  = 1;
		#10 clk  = 0;
		
		$strobe("auipc x9, 0");
		#10 inst = 'h00000497;
		#10 clk  = 1;
		#10 clk  = 0;
		
		$strobe("lw x1, -8(x9)");
		#10 inst = 'hff84a083;
		#10 clk  = 1;
		#10 clk  = 0;
		
		#10 inst = 'h00000000;
		#10 clk  = 1;
		#10 clk  = 0;
	end
endmodule
