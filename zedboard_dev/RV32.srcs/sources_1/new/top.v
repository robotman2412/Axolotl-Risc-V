`timescale 1ns / 1ps

/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

module top(
	output wire[3:0] VGA_R,
	output wire[3:0] VGA_G,
	output wire[3:0] VGA_B,
	output wire      VGA_VS,
	output wire      VGA_HS,
	input  wire      GCLK,
	input  wire      BTNC,
	input  wire      BTND,
	input  wire      BTNL,
	input  wire      BTNR,
	input  wire      BTNU,
	input  wire[7:0] SW,
	output wire[7:0] LED,
	output wire      txd,
	input  wire      rxd
);
	localparam clk_in         = 100_000_000;
	localparam baudrate       = 9600;
	localparam uart_div_const = clk_in / 8 / baudrate;
	localparam mem_size       = 0;
	
	// CPU core clock.
	wire       core_clk;
	
	// VGA interface.
	wire[6:0] char_x;
	wire[6:0] char_y;
	reg [7:0] char;
	
	// The text overlay.
	wire[13:0] overlay_addr = char_x | (char_y << 7);
	wire[7:0]  overlay_data;
	
	vga vga(VGA_R, VGA_G, VGA_B, VGA_VS, VGA_HS, GCLK, char_x, char_y, char | overlay_data);
	overlay_rom overlay_rom(overlay_addr, GCLK, overlay_data);
	
	// First address of memory view.
	reg [31:0] mem_view_base = 'hdeadbeef;
	// Current address of memory view.
	wire[31:0] mem_view_addr = mem_view_base + (char_y << 4) + (char_x >= 40 ? (char_x - 40) >> 4 : 0);
	// Current data word of memory view.
	wire[31:0] mem_view_data = 'h01234567;
	
	// Current data word of register view.
	wire[31:0] reg_view_data = 'h01234567;
	
	// Nibble to hexadecimal converter.
	reg [3:0] nibble;
	wire[7:0] hex     = (nibble <= 9) ? ('h30 | nibble) : (nibble + ('h41 - 'h0a));
	
	// Character selector.
	always @(*) begin
		if (char_x >= 4 && char_x < 12 && char_y < 32) begin
			// TODO: Hexits for regfile.
			nibble = reg_view_data >> (28 - (char_x - 4) * 4);
			char   = hex;
		end else if (char_x >= 28 && char_x < 36 && char_y < 64) begin
			// Address of memory view.
			nibble = mem_view_addr >> (28 - (char_x - 28) * 4);
			char   = hex;
		end else if (char_x >= 40 && char_y < 64) begin
			// Data of memory view.
			if (char_x[3:0] == 8) begin
				nibble = mem_view_data[7:4];
				char   = hex;
			end else if (char_x[3:0] == 9) begin
				nibble = mem_view_data[3:0];
				char   = hex;
				
			end else if (char_x[3:0] == 11) begin
				nibble = mem_view_data[15:12];
				char   = hex;
			end else if (char_x[3:0] == 12) begin
				nibble = mem_view_data[11:8];
				char   = hex;
				
			end else if (char_x[3:0] == 15) begin
				nibble = mem_view_data[23:20];
				char   = hex;
			end else if (char_x[3:0] == 0) begin
				nibble = mem_view_data[19:16];
				char   = hex;
				
			end else if (char_x[3:0] == 2) begin
				nibble = mem_view_data[31:28];
				char   = hex;
			end else if (char_x[3:0] == 3) begin
				nibble = mem_view_data[27:24];
				char   = hex;
				
			end else begin
				nibble = 0;
				char   = 0;
			end
		end else begin
			nibble = 0;
			char   = 0;
		end
	end
	
	// UART clock divider.
	reg[15:0] uart_clk_div = 0;
	reg[2:0]  uart_clk     = 0;
	always @(posedge GCLK) begin
		if (uart_clk_div == uart_div_const) begin
			uart_clk_div <= 0;
			uart_clk     <= uart_clk + 1;
		end else begin
			uart_clk_div <= uart_clk_div + 1;
		end
	end
	
	// // Simple UART setup.
	// wire rx_busy, tx_busy, rx_trig;
	// wire[7:0] rx_byte;
	// assign LED = rx_byte;
	// unbuffered_uart_tx uart_tx(uart_clk[2], SW, BTNC, txd, tx_busy);
	// unbuffered_uart_rx uart_rx(uart_clk, rx_byte, rx_trig, rxd, rx_busy);
	
	// UART loopback.
	wire rx_busy, tx_busy, trig;
	wire[7:0] rx_byte;
	reg [7:0] rx_count = 0;
	assign LED = rx_byte;
	unbuffered_uart_tx uart_tx(uart_clk[2], rx_count, trig, txd, tx_busy);
	unbuffered_uart_rx uart_rx(uart_clk, rx_byte, trig, tx_busy, rxd, rx_busy);
	
	always @(posedge trig) begin
		rx_count <= rx_count + 1;
	end
	
endmodule
