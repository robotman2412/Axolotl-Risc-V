
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

// Converts a dual-port (read, read/write) access interface into a single port.
// Prioritises the read/write port.
module axu_mem_rrw_rw(
	// Common clock signal.
	input  wire       clk,
	
	// Port 0 read enable.
	input  wire       re0,
	// Port 0 memory access size in 2^n bytes.
	input  wire[1:0]  asize0,
	// Port 0 ready.
	output wire       ready0,
	
	// Port 0 address.
	input  wire[31:0] addr0,
	// Port 0 data.
	output wire[31:0] data0,
	
	
	// Port 1 read enable.
	input  wire       re1,
	// Port 1 write enable.
	input  wire       we1,
	// Port 1 memory access size in 2^n bytes.
	input  wire[1:0]  asize1,
	// Port 1 ready.
	output wire       ready1,
	
	// Port 1 address.
	input  wire[31:0] addr1,
	// Port 1 data.
	inout  wire[31:0] data1,
	
	
	// Combined read enable.
	output wire       re2,
	// Combined write enable.
	output wire       we2,
	// Combined memory access size in 2^n bytes.
	output wire[1:0]  asize2,
	// Combined ready.
	input  wire       ready2,
	
	// Combined address.
	output wire[31:0] addr2,
	// Combined data.
	inout  wire[31:0] data2
);
	// Active port index.
	reg active_port;
	
	// Forwarding logic.
	assign re2    = active_port ? re1 : re0;
	assign we2    = active_port & we1;
	assign addr2  = active_port ? addr1 : addr0;
	assign asize2 = active_port ? asize1 : asize0;
	
	assign ready0 = active_port == 0 && ready2;
	assign data0  = active_port == 0 && re0 ? data2 : 'bz;
	
	assign ready1 = active_port == 1 && ready2;
	assign data1  = active_port == 1 && re1 ? data2 : 'bz;
	assign data2  = active_port == 1 && we1 ? data1 : 'bz;
	
	// Port selection logic.
	always @(negedge clk) begin
		active_port = re1 | we1;
	end
	
endmodule
