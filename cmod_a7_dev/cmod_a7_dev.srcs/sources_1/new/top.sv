
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
    reg rst = 0;
    logic[15:0] irq;
    
    // Simple clock generation logic.
    reg[5:0] clk_div;
    reg[8:0] uart_clk_div;
    reg      uart_clk;
    always @(posedge clk) begin
        if (uart_clk_div == 312) begin
            uart_clk_div <= 0;
            uart_clk     <= 0;
        end else if (uart_clk_div == 156) begin
            uart_clk_div <= uart_clk_div + 1;
            uart_clk     <= 1;
        end else begin
            uart_clk_div <= uart_clk_div + 1;
        end
        clk_div <= clk_div + 1;
        rst     <= btn[1];
    end
    wire subclk_fast = clk_div[3];
    wire subclk_slow = clk_div[5];
    
    // Memory.
    axo_mem_bus mem_buses[2]();
    axo_mem_bus cpu_buses[2]();
    
    blockram_32k bram(subclk_fast, subclk_slow, mem_buses[0]);
    
    axo_mem_xbar xbar(
        subclk_slow, rst, cpu_buses, mem_buses,
        '{0, 256}, '{8, 8}
    );
    
    // Peripherals.
    axo_peri_bus peri_bus();
    axo_mem_peri_bridge bridge(mem_buses[1], peri_bus);
    // wire[1:0] iolevel;
    // wire[1:0] iodir;
    // wire[1:0] iosense;
    // assign led_r      = iolevel[0];
    // assign iosense[0] = led_r;
    // assign iosense[1] = btn[0];
    // axo_peri_gpio#(2) gpio(subclk_slow, peri_bus, iolevel, iodir, iosense);
    wire rxd_full;
    wire txd_empty;
    assign irq[0] = rxd_full;
    axo_peri_uart uart(subclk_slow, rst, peri_bus, uart_clk, uart_send, uart_recv, rxd_full, txd_empty);
    
    // CPU core.
    wire ready;
    assign irq[15:1] = 0;
    axo_rv32im_zicsr#(.entrypoint(0)) cpu(subclk_slow, 0, rst, ready, cpu_buses[0], cpu_buses[1], irq);
    
    // PMOD.
    assign pmod[0] = uart_send;
    assign pmod[1] = uart_recv;
    assign pmod[2] = irq[0];
    assign pmod[3] = cpu.csrs.csr_mstatus_mie;
    assign pmod[4] = cpu.tr_trap;
    assign pmod[5] = cpu.tr_is_interrupt;
    assign pmod[6] = cpu.tr_ie[16];
    assign pmod[7] = cpu.clk;
    
    // Blinkenlights.
    assign led_b = ready;
    assign led_r = uart_send;
    assign led_g = 1;
endmodule
