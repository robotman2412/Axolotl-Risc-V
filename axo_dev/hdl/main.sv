
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps

module main(
    input  logic    clk_fast,
    input  logic    rst,
    output logic    ready,
    input  logic    clk_uart,
    output logic    txd,
    input  logic    rxd
);
    `include "axo_functions.sv"
    logic[15:0] irq;
    assign irq = 0;
    
    // Clock generation.
    reg clk_div  = 0;
    reg clk_slow = 0;
    always @(posedge clk_fast) begin
        if (clk_div) clk_slow <= !clk_slow;
        clk_div <= !clk_div;
    end
    
    // Memory busses.
    axo_mem_bus  mbus[3]();
    axo_mem_bus  cbus[2]();
    axo_peri_bus pbus();
    
    // UART peripheral.
    logic rx_full, tx_empty;
    axo_peri_uart uart(clk_slow, rst, pbus, clk_uart, txd, rxd, rx_full, tx_empty);
    
    // Bootstrap ROM.
    aligned_ram#(
        .abits(10), .init_file({axo_parentdir(`__FILE__), "/../build/rom.mem"}), .is_rom(1)
    ) rom(clk_fast, clk_slow, mbus[0]);
    // Internal RAM.
    aligned_ram#(.abits(10)) ram(clk_fast, clk_slow, mbus[1]);
    // Peripheral bridge.
    axo_mem_peri_bridge bridge(mbus[2], pbus);
    
    // Memory crossbar.
    axo_mem_xbar#(.cpus(2), .mems(3)) xbar(
        clk_slow, rst, cbus, mbus,
        '{32'h000, 32'h400, 32'h800},
        '{10,      10,      10     }
    );
    
    // CPU core.
    axo_rv32im_zicsr#(.entrypoint(0)) cpu(clk_slow, 0, rst, ready, cbus[0], cbus[1], irq);
endmodule
