
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps
`include "axo_defines.sv"



module blockram_32k(
    // RAM clock, at least twice as fast as desired transfer rate.
    input logic clk_fast,
    // RAM latch clock, synchronized to write enable.
    input logic clk_slow,
    // Axo memory bus interface.
    axo_mem_bus.MEM bus
);
    // Current address in the block RAM.
    reg  [11:0] cur_addr;
    assign bus.error = 0;
    assign bus.ready = cur_addr == bus.addr[11:0];
    
    always @(posedge clk_fast) begin
        cur_addr <= bus.addr;
    end
    
    logic[3:0] we;
    assign we[0] = bus.asize >= 0 && bus.we;
    assign we[1] = bus.asize >= 1 && bus.we;
    assign we[2] = bus.asize >= 2 && bus.we;
    assign we[3] = bus.asize >= 2 && bus.we;
    
    // Raw block RAM.
    memory_wrapper bram(
        bus.addr,
        clk_fast,
        wdata_reg,
        bus.rdata,
        clk_slow ? 0 : we
    );
endmodule
