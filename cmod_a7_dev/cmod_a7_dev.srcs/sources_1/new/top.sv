
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
    output logic        led_b
);
    (* mark_debug = "true" *)
    reg rst = 0;
    
    // Simple clock generation logic.
    reg[9:0] clk_div;
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
        rst     <= btn[1];
    end
    wire subclk_fast = clk_div[7];
    wire subclk_slow = clk_div[9];
    
    // Memory.
    axo_mem_bus mem_buses[2]();
    axo_mem_bus cpu_buses[2]();
    
    blockram_32k bram(subclk_fast, mem_buses[0]);
    
    axo_mem_xbar xbar(
        subclk_slow, rst, cpu_buses, mem_buses,
        '{0, 256}, '{8, 8}
    );
    
    // GPIO.
    axo_peri_bus peri_bus();
    axo_mem_peri_bridge bridge(mem_buses[1], peri_bus);
    axo_peri_gpio#(2) gpio(clk, peri_bus, '{led_r, btn[0]});
    
    // CPU core.
    wire ready;
    axo_rv32im_zicsr#(.entrypoint(0), .hcf_on_trap(1)) cpu(subclk_slow, 0, rst, ready, cpu_buses[0], cpu_buses[1], 16'h0000);
    
    // Blinkenlights.
    assign led_b = ready;
    assign led_g = !rst;
endmodule
