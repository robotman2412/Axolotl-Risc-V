
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps



// Single-port block memory.
module raw_block_ram#(
    // Number of address bits.
    parameter int    abits       = 8,
    // Number of data bytes.
    parameter int    dbytes      = 4,
    // Byte size.
    parameter int    blen        = 8,
    // Generate write-before-read instead of read-before-write.
    parameter bit    write_first = 0,
    // Initialization file, or "none" if not used.
    // The file must contain hexadecimal values seperated by commas.
    parameter string init_file   = "",
    
    // Number of data bits.
    localparam       dbits       = dbytes * blen
)(
    // RAM clock.
    input  logic                clk,
    // Per-byte write enable.
    input  logic[dbytes-1:0]    we,
    // Address.
    input  logic[abits-1:0]     addr,
    // Write data.
    input  logic[dbits-1:0]     wdata,
    // Read data.
    output logic[dbits-1:0]     rdata
);
    `include "axo_functions.sv"
    
    xpm_memory_spram#(
        .ADDR_WIDTH_A(abits),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(blen),
        .CASCADE_HEIGHT(0),
        .MEMORY_INIT_FILE(init_file == "" ? "none" : init_file),
        .MEMORY_SIZE(dbits << abits),
        .READ_DATA_WIDTH_A(dbits),
        .READ_LATENCY_A(1),
        .WRITE_DATA_WIDTH_A(dbits),
        .WRITE_MODE_A(write_first ? "write_first" : "read_first")
    ) bram_inst (
        .addra(addr),
        .clka(clk),
        .dina(wdata),
        .douta(rdata),
        .ena(1),
        .injectdbiterra(0),
        .injectsbiterra(0),
        .regcea(1),
        .rsta(0),
        .sbiterra(),
        .sleep(0),
        .wea(we)
    );
endmodule
