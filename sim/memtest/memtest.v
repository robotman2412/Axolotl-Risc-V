
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "memories.v"

module top(
);
	reg clk;
	reg[31:0] addr;
	reg[31:0] wdata;
	wire[31:0] data;
	reg[1:0] asize;
	reg we;
	wire re = !we;
	assign data = we ? wdata : 'bz;
	wire alignerr;
	
	aligned_ram #(.addr_width(32), .depth(256)) mem(
		clk,
		re, we,
		asize, addr, data,
		alignerr
	);
	
	initial begin
		asize <= 1;
		
		// Init write.
		#10 addr  <= 'hc0;
		#10 wdata <= 'hcafe;
		#10 we  <= 1;
		#10 clk <= 1;
		$strobe("W %08h = %08h   E(%0d)", addr, data, alignerr);
		#10 we  <= 0;
		#10 clk <= 0;
		
		// Init read.
		#10 addr <= 'hc0;
		$strobe("R %08h = %08h   E(%0d)", addr, data, alignerr);
		
		// Init write.
		#10 addr  <= 'hdc;
		#10 wdata <= 'h9876;
		#10 we  <= 1;
		#10 clk <= 1;
		$strobe("W %08h = %08h   E(%0d)", addr, data, alignerr);
		#10 we  <= 0;
		#10 clk <= 0;
		
		// Init read.
		#10 addr <= 'hdc;
		$strobe("R %08h = %08h   E(%0d)", addr, data, alignerr);
	end
endmodule
