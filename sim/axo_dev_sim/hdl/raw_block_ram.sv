
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
    // Initialization file, if any.
    parameter string init_file   = ""
)(
    // RAM clock.
    input  logic            clk,
    // Per-byte write enable.
    input  logic[blen-1:0]  we,
    // Address.
    input  logic[abits-1:0] addr,
    // Write data.
    input  logic[dbits-1:0] wdata,
    // Read data.
    output logic[dbits-1:0] rdata
);
    genvar i;
    
    // Number of data bits.
    localparam dbits = dbytes * blen;
    
    // Data storage.
    reg[dbits-1:0] storage[1 << abits];
        
    // Initial value in simulation.
    initial begin
        integer i;
        for (i = 0; i < 1 << abits; i = i + 1) begin
            storage[i] = 0;
        end
    end
    
    generate
        // Read logic.
        if (write_first) begin: gen_bram_wfirst
            for (i = 0; i < dbytes; i = i + 1) begin
                always @(posedge clk) begin
                    if (we[i]) begin
                        rdata[(i+1)*blen-1:i*blen] <= wdata[(i+1)*blen-1:i*blen];
                    end else begin
                        rdata[(i+1)*blen-1:i*blen] <= storage[addr][(i+1)*blen-1:i*blen];
                    end
                end
            end
        end else begin: gen_bram_rfirst
            always @(posedge clk) begin
                rdata <= storage[addr];
            end
        end
        
        // Write logic.
        for (i = 0; i < dbytes; i = i + 1) begin
            always @(posedge clk) begin
                if (we[i]) begin
                    storage[addr][(i+1)*blen-1:i*blen] <= wdata[(i+1)*blen-1:i*blen];
                end
            end
        end
    endgenerate
    
    // Displaying logic.
    logic[dbits-1:0] smask;
    generate
        for (i = 0; i < dbytes; i = i + 1) begin
            always @(*) begin
                if (we[i]) begin
                    smask[(i+1)*blen-1:i*blen] = wdata[(i+1)*blen-1:i*blen];
                end else begin
                    smask[(i+1)*blen-1:i*blen] = storage[addr][(i+1)*blen-1:i*blen];
                end
            end
        end
    endgenerate
    always @(posedge clk) begin
        if (we != 0) begin
            $display("[%x] = %x", addr, smask);
        end
    end
endmodule
