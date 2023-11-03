
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps

module top(
    // Global 12MHz clock input.
    input  wire         clk,
    
    // USB-UART send.
    output wire         uart_send,
    // USB-UART receive.
    input  wire         uart_recv,
    
    // Buttons on top of the board.
    inout  wire [1:0]   btn,
    
    // RGB LED on top of the board.
    output logic        led_r,
    output logic        led_g,
    output logic        led_b,
    
    // PMOD JA.
    output wire[7:0]    pmod
);
    reg[1:0] div;
    always @(posedge clk) begin
        div <= div + 1;
    end
    main main(div[1], btn[1]);
    
    // Blinkenlights.
    assign led_b = 1;
    assign led_r = 1;
    assign led_g = 1;
endmodule
