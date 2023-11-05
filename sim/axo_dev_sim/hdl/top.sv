
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps

module top(
    input  logic clk
);
    wire ready, txd;
    main main(clk, 0, ready, clk, txd, 1);
endmodule
