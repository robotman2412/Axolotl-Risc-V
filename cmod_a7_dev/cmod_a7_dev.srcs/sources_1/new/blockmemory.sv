
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps
`include "axo_defines.sv"



module blockram_32k(
    // Should be twice as fast as desired transfer rate.
    input wire clk,
    // Axo memory bus interface.
    axo_mem_bus.MEM bus
);
    // Current address in the block RAM.
    reg  [13:2] cur_addr;
    assign bus.error = 0;
    assign bus.ready = 1;
    
    always @(posedge clk) begin
        cur_addr <= bus.addr;
    end
    
    // Raw block RAM.
    memory_wrapper bram(
        bus.addr >> 2,
        clk,
        bus.wdata,
        bus.rdata,
        0
    );
endmodule



// module blockram_32k(
//     // Should be twice as fast as desired transfer rate.
//     input wire clk,
//     // Axo memory bus interface.
//     axo_mem_bus.MEM bus
// );
//     // Data to write to the memory.
//     logic[31:0] wdata;
//     // Data to read from the memory.
//     wire [31:0] rdata;
//     // Per-byte write enable.
//     logic[3:0]  we;
    
//     // Current address in the block RAM.
//     reg  [16:2] cur_addr;
    
//     // Access logic.
//     always @(*) begin
//         if (bus.asize == 3) begin
//             // Illegal access size.
//             bus.ready = 1;
//             bus.error = 1;
//             bus.rdata = `AXO_MEM_EASIZE;
//             wdata     = 'bx;
//             we        = 4'b0000;
//         end else if (bus.asize == 2) begin
//             if (bus.addr[1:0] != 0) begin
//                 // Address misaligned.
//                 bus.ready = 1;
//                 bus.error = 1;
//                 bus.rdata = `AXO_MEM_EALIGN;
//                 wdata     = 'bx;
//                 we        = 4'b0000;
//             end else begin
//                 // 32-bit access.
//                 bus.ready = cur_addr == bus.addr[16:14];
//                 bus.error = 0;
//                 bus.rdata = rdata;
//                 wdata     = bus.wdata;
//                 we        = bus.ready && bus.we ? 15 : 0;
//             end
//         end else if (bus.asize == 1) begin
//             if (bus.addr[0] != 0) begin
//                 // Address misaligned.
//                 bus.ready = 1;
//                 bus.error = 1;
//                 bus.rdata = `AXO_MEM_EALIGN;
//                 wdata     = 'bx;
//                 we        = 4'b0000;
//             end else begin
//                 // 32-bit access.
//                 bus.ready       = cur_addr == bus.addr[16:14];
//                 bus.error       = 0;
//                 bus.rdata       = bus.addr[1] ? rdata[31:16] : rdata[15:0];
//                 wdata[31:16]    = bus.wdata[15:0];
//                 wdata[15:0]     = bus.wdata[15:0];
//                 we              = bus.ready && bus.we ? {bus.addr[1], bus.addr[1], !bus.addr[1], !bus.addr[1]} : 0;
//             end
//         end else begin
//             // 8-bit access.
//             bus.ready       = cur_addr == bus.addr[16:14];
//             bus.error       = 0;
//             bus.rdata       = bus.addr[1:0] == 3 ? rdata[31:24]
//                             : bus.addr[1:0] == 2 ? rdata[23:16]
//                             : bus.addr[1:0] == 1 ? rdata[15:0]
//                             : rdata[7:0];
//             wdata[31:24]    = bus.wdata[7:0];
//             wdata[23:16]    = bus.wdata[7:0];
//             wdata[15:8]     = bus.wdata[7:0];
//             wdata[7:0]      = bus.wdata[7:0];
//             we              = bus.ready && bus.we ? (4'd1 << bus.addr[1:0]) : 0;
//         end
//     end
    
//     // Raw block RAM.
//     memory_wrapper bram(
//         bus.addr >> 2,
//         clk,
//         wdata,
//         rdata,
//         we
//     );
// endmodule
