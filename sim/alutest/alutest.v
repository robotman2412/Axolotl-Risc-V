
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_base.v"

module aluprinter(
	input wire clk,
	input wire[31:0] a,
	input wire[31:0] b,
	input wire[2:0] funct3,
	input wire inst30
);
	axo_alu alu(
		funct3,
		inst30,
		1'b0,
		a, b,
		q
	);
	wire [31:0]q;
	wire signed [31:0]sa = a;
	wire signed [31:0]sb = b;
	wire signed [31:0]sq = q;
	
	always @(posedge clk) begin
		$strobe("funct3=%03b  inst30=%b:", funct3, inst30);
		$strobe("\t0x%08h, 0x%08h -> 0x%08h", a, b, q);
		$strobe("\t%10d, %10d -> %10d", a, b, q);
		$strobe("\t%10d, %10d -> %10d", sa, sb, sq);
		$strobe("");
	end
	
endmodule

module top(
);
	reg clk;
	reg[31:0] a;
	reg[31:0] b;
	reg[2:0] funct3;
	reg inst30;
	
	aluprinter _(
		clk,
		a, b,
		funct3, inst30
	);
	
	initial begin
		$write("ADD:  ");
		a = 3; b = 9;
		funct3 = `RV_ALU_ADD;
		inst30 = 0;
		#10 clk = 1;
		#10 clk = 0;
		
		
		$write("SUB:  ");
		a = 3; b = 9;
		funct3 = `RV_ALU_ADD;
		inst30 = 1;
		#10 clk = 1;
		#10 clk = 0;
		
		
		$write("SLL:  ");
		a = 'hc3c3; b = 9;
		funct3 = `RV_ALU_SLL;
		inst30 = 0;
		#10 clk = 1;
		#10 clk = 0;
		
		
		$write("SRL:  ");
		a = 'hf00dbabe; b = 12;
		funct3 = `RV_ALU_SRL;
		inst30 = 0;
		#10 clk = 1;
		#10 clk = 0;
		
		
		$write("SRA:  ");
		a = 'hf00dbabe; b = 12;
		funct3 = `RV_ALU_SRL;
		inst30 = 1;
		#10 clk = 1;
		#10 clk = 0;
		
		
		$write("XOR:  ");
		a = 'hcccc3333; b = 'h99996666;
		funct3 = `RV_ALU_XOR;
		inst30 = 0;
		#10 clk = 1;
		#10 clk = 0;
	end
endmodule
