
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ns

// Standard Axo memory bus.
// Assumes both sides have a common clock.
interface axo_mem_bus#(
    // Data width, powers of 2 >= 32.
    parameter       dlen = 32,
    // Address width.
    parameter       alen = 32
);
    // CPU -> MEM: Read enable.
    logic           re;
    // CPU -> MEM: Write enable.
    logic           we;
    // CPU -> MEM: Log2 of access size.
    logic[1:0]      asize;
    // MEM -> CPU: Ready to transfer.
    logic           ready;
    // MEM -> CPU: Alignment error.
    logic           alignerr;
    // CPU -> MEM: Memory address.
    logic[dlen-1:0] addr;
    // CPU <> MEM: Transfer data.
    wire [alen-1:0] data;
    
    // Directions from CPU perspective.
    modport CPU (output re, we, asize, addr, input ready, alignerr, inout data);
    // Directions from MEM perspective.
    modport MEM (output ready, alignerr, input re, we, asize, addr, inout data);
endinterface


// Configurable Axo memory bus crossbar.
// Any MEM occupies a NAPOT range at least 4 bytes large in the address space.
// No two MEMs may have any overlap.
module axo_mem_xbar#(
    // Data width, powers of 2 >= 32.
    parameter   dlen = 32,
    // Address width.
    parameter   alen = 32,
    
    // Number of CPU bus interfaces, at least 2.
    parameter   cpus = 2,
    // Number of MEM bus interfaces, at least 2.
    parameter   mems = 2,
    
    // Memory base addresses.
    parameter   bases,
    // Log2 of memory size.
    parameter   sizes
)(
);
endmodule
