
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_rv32i.v"

module top(
);
	reg clk; wire crash;
	wire mem_re, mem_we; wire[1:0] mem_asize;
	wire[31:0] mem_addr, mem_data;
	wire prog_re;
	wire[31:0] prog_addr, prog_data;
	axo_rv32i cpu(
		clk, 1'b0, crash,
		mem_re, mem_we, mem_asize, 1'b1,
		mem_addr, mem_data,
		prog_re, 1'b1,
		prog_addr, prog_data
	);
	
	reg[31:0] prog_mem[31:0];
	assign prog_data = prog_mem[prog_addr>>2];
	
	initial begin
		prog_mem[0] <= 'h02100093;
		prog_mem[1] <= 'h00108133;
		prog_mem[2] <= 'h00115193;
		prog_mem[3] <= 'hf00dc237;
		prog_mem[4] <= 'habe20213;
		
		#1000 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
		#100 clk <= 1;
		#100 clk <= 0;
	end
endmodule
