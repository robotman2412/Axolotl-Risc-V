`timescale 1ns / 1ps

/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
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
	output wire[7:0] LED
);
	wire[6:0] char_x;
	wire[6:0] char_y;
	wire[7:0] char = char_x[3:0] | (char_y[3:0] << 4);
	vga vga (VGA_R, VGA_G, VGA_B, VGA_VS, VGA_HS, GCLK, char_x, char_y, char);
endmodule
