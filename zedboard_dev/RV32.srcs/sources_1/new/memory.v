`timescale 1ns / 1ps

/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

module memory(
	// CPU interface naturally aligned byte-addressable.
	input  wire       clk_a,
	input  wire[31:0] addr_a,
	inout  wire[31:0] data_a,
	input  wire       re_a,
	input  wire       we_a,
	input  wire[1:0]  asize_a,
	output wire       alignerr_a,
	// Debug interface word-aligned word-addressable.
	input  wire       clk_b,
	input  wire[31:0] addr_b,
	input  wire[31:0] din_b,
	output wire[31:0] dout_b,
	input  wire       we_b
);
	// Read interface A.
	wire[12:0] m_addra = addr_a >> 2;
	reg [31:0] m_dina;
	wire[31:0] m_douta;
	reg [3:0]  m_wea;
	
	// Port A write logic.
	always @(*) begin
		if (asize_a == 0) begin
			// One byte access.
			alignerr_a = 0;
			m_dina     = data_a[7:0] << (8 * addr_a[1:0]);
			m_wea[0]   = we_a && addr_a[1:0] == 0;
			m_wea[1]   = we_a && addr_a[1:0] == 1;
			m_wea[2]   = we_a && addr_a[1:0] == 2;
			m_wea[3]   = we_a && addr_a[1:0] == 3;
		end else if (asize_a == 1) begin
			// Two byte access.
			alignerr_a = addr_a[0];
			m_dina     = data_a[15:0] << (16 * addr_a[1]);
			m_wea[3:2] = (we_a &&  addr_a[1]) ? 3 : 0;
			m_wea[1:0] = (we_a && ~addr_a[1]) ? 3 : 0;
		end else if (asize_a == 2) begin
			// Four byte access.
			alignerr_a = addr_a[1:0] != 0;
			m_dina     = data_a;
			m_wea      = we_a ? 15 : 0;
		end else begin
			// Eight byte access (unsupported).
			alignerr_a = 1;
			m_dina     = 0;
			m_wea      = 0;
		end
	end
endmodule
