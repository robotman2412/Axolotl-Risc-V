`timescale 1ns / 1ps

/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

module vga(
	output wire[3:0] VGA_R,
	output wire[3:0] VGA_G,
	output wire[3:0] VGA_B,
	output wire      VGA_VS,
	output wire      VGA_HS,
	input  wire      GCLK,
	output reg [6:0] next_char_x,
	output reg [6:0] next_char_y,
	input  wire[7:0] char
);
	// Horizontal timing parameters.
	localparam h_vid_off  =  800;
	localparam h_sync_on  =  840;
	localparam h_sync_off =  968;
	localparam h_limit    = 1056;
	// Vertical timing parameters.
	localparam v_vid_off  =  600;
	localparam v_sync_on  =  601;
	localparam v_sync_off =  605;
	localparam v_limit    =  628;
	// TTY parameters.
	localparam n_char_x   =  100;
	localparam n_char_y   =  75;
	
	// VGA signal generation.
	reg[2:0]  clk_div;
	reg[10:0] pos_x;
	reg[9:0]  pos_y;
	reg       h_sync, v_sync;
	reg       h_sync_buf, v_sync_buf;
	reg       h_vid_enable, v_vid_enable;
	wire      vid_enable = h_vid_enable && v_vid_enable;
	reg       vid_enable_buf;
	
	wire[3:0] red;
	wire[3:0] green;
	wire[3:0] blue;
	
	assign     VGA_HS     = ~h_sync_buf;
	assign     VGA_VS     = ~v_sync_buf;
	assign     VGA_R      = vid_enable_buf ? red   : 0;
	assign     VGA_G      = vid_enable_buf ? green : 0;
	assign     VGA_B      = vid_enable_buf ? blue  : 0;
	
	// Character ROM.
	reg [7:0]  char_reg;
	wire[10:0] char_addr  = (char_reg << 3) | pos_y[2:0];
	wire[7:0]  char_data;
	char_rom char_rom(char_addr, GCLK, char_data);
	reg        char_bit;
	assign     red        = char_bit ? 15 : 0;
	assign     green      = char_bit ? 15 : 0;
	assign     blue       = char_bit ? 15 : 0;
	
	initial begin
		clk_div           = 0;
		char_reg          = 0;
		pos_x             = 0;
		pos_y             = 0;
		h_vid_enable      = 0;
		v_vid_enable      = 0;
		h_sync            = 0;
		v_sync            = 0;
		h_sync_buf        = 0;
		v_sync_buf        = 0;
		next_char_x       = 0;
		next_char_y       = 0;
	end
	
	always @(posedge GCLK) begin
		clk_div = clk_div + 1;
		if (clk_div == 2 || clk_div == 5) begin
			pos_x <= pos_x + 1;
			
			// Buffer the output signals.
			char_bit <= char_data[pos_x[2:0]];
			h_sync_buf <= h_sync;
			v_sync_buf <= v_sync;
			vid_enable_buf <= vid_enable;
			
			if (pos_x[2:0] == 7 && h_vid_enable) begin
				// Update character to show.
				char_reg     <= char;
				// Update next character position.
				next_char_x  <= next_char_x + 1;
			end
			
			if (pos_x == h_vid_off) begin
				// Front proch starts.
				h_vid_enable <= 0;
				// Update next character position.
				next_char_x  <= 0;
				if ((pos_y & 7) == 7) begin
					next_char_y <= v_vid_enable ? next_char_y + 1 : 0;
				end
			end else if (pos_x == h_sync_on) begin
				// Sync starts.
				h_sync       <= 1;
			end else if (pos_x == h_sync_off) begin
				// Sync ends.
				h_sync       <= 0;
			end else if (pos_x == h_limit) begin
				// Next line starts.
				h_vid_enable <= 1;
				pos_x        <= 0;
				char_reg     <= char;
				next_char_x  <= 1;
			end
		end
		if (clk_div == 5) begin
			clk_div <= 0;
		end
	end
	
	always @(posedge h_vid_enable) begin
		// Do the vertical.
		pos_y <= pos_y + 1;
		if (pos_y == v_vid_off) begin
			// Front proch starts.
			v_vid_enable <= 0;
		end else if (pos_y == v_sync_on) begin
			// Sync starts.
			v_sync       <= 1;
		end else if (pos_y == v_sync_off) begin
			// Sync ends.
			v_sync       <= 0;
		end else if (pos_y == v_limit) begin
			// Next frame starts.
			v_vid_enable <= 1;
			pos_y        <= 0;
		end
	end
endmodule
