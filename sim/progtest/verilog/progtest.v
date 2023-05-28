
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_rv32i.v"
`include "memories.v"
`include "program.v"

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
	
	program prog_rom(prog_addr>>2, prog_data);
	
	wire alignerr;
	aligned_ram #(.addr_width(32), .depth(256)) mem(
		clk,
		mem_re, mem_we,
		mem_asize, mem_addr, mem_data,
		alignerr
	);
	
	initial begin
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
