
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps
`include "axo_defines.sv"



// Naturally aligned 32-bit Axo bus RAM.
// Cyrrently broken.
module aligned_ram#(
    // Log2 of number of 32-bit words.
    parameter int    abits      = 8,
    // Initialization file, if any.
    parameter string init_file  = "",
    // ROM mode; writes will be rejected in ROM mode.
    parameter bit    is_rom     = 0
)(
    // Clock to synchronise against accesses.
    input  logic    clk_fast,
    // Clock for block RAM, must be exactly quarter of `clk_fast`.
    input  logic    clk_slow,
    
    // Axo memory port.
    axo_mem_bus.MEM bus
);
    // Per-byte write enable.
    logic[3:0]          we;
    // Write data for block RAM.
    logic[31:0]         wdata;
    // Read data from block RAM.
    logic[31:0]         rdata;
    
    // Raw block RAM storage.
    raw_block_ram#(abits, 4, 8, 0, init_file) bram_inst(clk_fast, we, bus.addr[abits+1:2], wdata, rdata);
    
    generate
        if (is_rom) begin
            // ROM does no writing.
            assign wdata = 0;
            assign we    = 0;
        end else begin
            // Write access logic.
            always @(*) begin
                if (bus.asize == 0) begin
                    wdata[31:24]    = bus.wdata[7:0];
                    wdata[23:16]    = bus.wdata[7:0];
                    wdata[15:8]     = bus.wdata[7:0];
                    wdata[7:0]      = bus.wdata[7:0];
                    we              = (!clk_slow && bus.we) << bus.addr[1:0];
                end else if (bus.asize == 1) begin
                    wdata[31:16]    = bus.wdata[15:0];
                    wdata[15:0]     = bus.wdata[15:0];
                    we[3:2]         = (!clk_slow && !bus.addr[0] && bus.we &&  bus.addr[1]) ? 2'b11 : 2'b00;
                    we[1:0]         = (!clk_slow && !bus.addr[0] && bus.we && !bus.addr[1]) ? 2'b11 : 2'b00;
                end else if (bus.asize == 2) begin
                    wdata           = bus.wdata;
                    we              = (!clk_slow && bus.addr[1:0] == 0 && bus.we) ? 4'b1111 : 4'b0000;
                end else begin
                    wdata           = 'bx;
                    we              = 0;
                end
            end
        end
    endgenerate
    
    // Read access and error logic.
    always @(*) begin
        if (is_rom && bus.we) begin
            bus.ready   = 1;
            bus.error   = 1;
            bus.rdata   = `AXO_MEM_READONLY;
        end else if (bus.asize == 0) begin
            bus.ready   = 1;
            bus.error   = 0;
            case (bus.addr[1:0])
                0: bus.rdata = rdata[7:0];
                1: bus.rdata = rdata[15:8];
                2: bus.rdata = rdata[23:16];
                3: bus.rdata = rdata[31:24];
            endcase
        end else if (bus.asize == 1) begin
            if (bus.addr[0]) begin
                bus.ready   = 1;
                bus.error   = bus.re || bus.we;
                bus.rdata   = `AXO_MEM_EALIGN;
            end else begin
                bus.ready   = 1;
                bus.error   = 0;
                bus.rdata   = bus.addr[1] ? rdata[31:16] : rdata[15:0];
            end
        end else if (bus.asize == 2) begin
            if (bus.addr[1:0]) begin
                bus.ready   = 1;
                bus.error   = bus.re || bus.we;
                bus.rdata   = `AXO_MEM_EALIGN;
            end else begin
                bus.ready   = 1;
                bus.error   = 0;
                bus.rdata   = rdata;
            end
        end else begin
            bus.ready   = 1;
            bus.error   = bus.re || bus.we;
            bus.rdata   = `AXO_MEM_EASIZE;
        end
    end
endmodule
