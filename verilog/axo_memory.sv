
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps
`include "axo_defines.sv"

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
    // CPU -> MEM: Memory address.
    logic[alen-1:0] addr;
    // CPU -> MEM: Write data.
    logic[dlen-1:0] wdata;
    
    // MEM -> CPU: Ready to transfer.
    logic           ready;
    // MEM -> CPU: Error.
    logic           error;
    // MEM -> CPU: Read data.
    logic[dlen-1:0] rdata;
    
    // Directions from CPU perspective.
    modport CPU (output re, we, asize, addr, wdata, input ready, error, rdata);
    // Directions from MEM perspective.
    modport MEM (output ready, error, rdata, input re, we, asize, addr, wdata);
endinterface



// Configurable Axo memory bus demultiplexer.
// The MEM occupies a NAPOT range at least 4 bytes large in the address space.
module axo_mem_demux#(
    // Data width, powers of 2 >= 32.
    parameter integer   dlen = 32,
    // Address width.
    parameter integer   alen = 32,
    
    // Number of CPU to demultiplexer ports, at least 2.
    parameter integer   cpus = 2
)(
    // Shared clock.
    input logic clk,
    // Shared reset.
    input logic rst,
    
    // CPU to demultiplexer ports.
    axo_mem_bus.MEM cpu_ports[cpus],
    // Demultiplexer to MEM port.
    axo_mem_bus.CPU mem_port
);
    genvar i;
    
    // Last CPU to use the memory.
    reg  [cpus-1:0] last_cpu = 1;
    
    // Memory is currently occupied.
    logic[cpus-1:0] occupied;
    generate
        for (i = 0; i < cpus; i = i + 1) begin
            assign occupied[i] = last_cpu[i] && (cpu_ports[i].re || cpu_ports[i].we);
        end
    endgenerate
    wire            any_occupied = occupied != 0;
    
    // Arbitration logic.
    logic[cpus*2-1:0] arbiter;
    assign arbiter[0] = 0;
    assign arbiter[cpus] = last_cpu[cpus-1]
            || (arbiter[cpus-1] && !cpu_ports[cpus-1].re && !cpu_ports[cpus-1].we);
    generate
        for (i = 1; i < cpus; i = i + 1) begin
            assign arbiter[i] = last_cpu[i-1]
                    || (arbiter[i-1] && !cpu_ports[i-1].re && !cpu_ports[i-1].we);
            assign arbiter[i+cpus] = last_cpu[i-1]
                    || (arbiter[i-1] && !cpu_ports[i-1].re && !cpu_ports[i-1].we);
        end
    endgenerate
    
    // /* verilator lint_off UNOPTFLAT */
    // logic[cpus-1:0] arbiter;
    // assign arbiter[0] = last_cpu[cpus-1]
    //         || (arbiter[cpus-1] && !cpu_ports[cpus-1].re && !cpu_ports[cpus-1].we);
    // generate
    //     for (i = 1; i < cpus; i = i + 1) begin
    //         assign arbiter[i] = last_cpu[i-1]
    //                 || (arbiter[i-1] && !cpu_ports[i-1].re && !cpu_ports[i-1].we);
    //     end
    // endgenerate
    // /* verilator lint_on UNOPTFLAT */
    
    // Next CPU to use the memory.
    logic[cpus-1:0] next_cpu;
    generate
        for (i = 0; i < cpus; i = i + 1) begin
            assign next_cpu[i] = (arbiter[i] || arbiter[i+cpus]) && (cpu_ports[i].re || cpu_ports[i].we);
        end
    endgenerate
    
    // logic[cpus-1:0] next_cpu;
    // generate
    //     for (i = 0; i < cpus; i = i + 1) begin
    //         assign next_cpu[i] = arbiter[i] && (cpu_ports[i].re || cpu_ports[i].we);
    //     end
    // endgenerate
    
    // Arbitration at negedge, when RE and WE are stable.
    always @(negedge clk) begin
        if (!any_occupied) begin
            last_cpu <= next_cpu ? next_cpu : last_cpu;
        end
    end
    
    // Memory connection logic.
    generate
        for (i = 0; i < cpus; i = i + 1) begin
            assign cpu_ports[i].ready = mem_port.ready && last_cpu[i];
            assign cpu_ports[i].error = mem_port.error && last_cpu[i];
            assign cpu_ports[i].rdata = mem_port.rdata;
        end
    endgenerate
    
    logic           masked_re[cpus];
    logic           masked_we[cpus];
    logic[1:0]      masked_asize[cpus];
    logic[alen-1:0] masked_addr[cpus];
    logic[dlen-1:0] masked_wdata[cpus];
    generate
        for (i = 0; i < cpus; i = i + 1) begin
            assign masked_re[i]     = last_cpu[i] && cpu_ports[i].re;
            assign masked_we[i]     = last_cpu[i] && cpu_ports[i].we;
            assign masked_asize[i]  = last_cpu[i] ?  cpu_ports[i].asize : 0;
            assign masked_addr[i]   = last_cpu[i] ?  cpu_ports[i].addr  : 0;
            assign masked_wdata[i]  = last_cpu[i] ?  cpu_ports[i].wdata : 0;
        end
    endgenerate
    always @(*) begin
        integer i;
        mem_port.re    = 0;
        mem_port.we    = 0;
        mem_port.asize = 0;
        mem_port.addr  = 0;
        for (i = 0; i < cpus; i = i + 1) begin
            mem_port.re    |= masked_re   [i];
            mem_port.we    |= masked_we   [i];
            mem_port.asize |= masked_asize[i];
            mem_port.addr  |= masked_addr [i];
        end
    end
    
    always @(*) begin
        integer i;
        mem_port.wdata = 0;
        for (i = 0; i < cpus; i = i + 1) begin
            mem_port.wdata |= masked_wdata[i];
        end
    end
endmodule



// Configurable Axo memory bus multiplexer.
// Any MEM occupies a NAPOT range at least 4 bytes large in the address space.
// No two MEMs may overlap.
module axo_mem_mux#(
    // Data width, powers of 2 >= 32.
    parameter integer   dlen = 32,
    // Address width.
    parameter integer   alen = 32,
    
    // Number of multiplexer to MEM ports, at least 2.
    parameter integer   mems = 2
)(
    // Shared clock.
    input logic clk,
    // Shared reset.
    input logic rst,
    
    // CPU to demultiplexer ports.
    axo_mem_bus.MEM cpu_port,
    // Demultiplexer to MEM port.
    axo_mem_bus.CPU mem_ports[mems],
    
    // Memory base addresses.
    input logic[alen-1:0] bases[mems],
    // Log2 of memory size.
    input logic[alen-1:0] sizes[mems]
);
    // Memory selection logic.
    logic[alen-1:0] xor_addr[mems];
    logic[mems-1:0] target;
    generate
        genvar i;
        for (i = 0; i < mems; i = i + 1) begin
            assign xor_addr[i] = (cpu_port.addr ^ bases[i]) & ((64'b1 << alen) - (64'b1 << sizes[i]));
            assign target[i]   = xor_addr[i] == 0;
        end
    endgenerate
    
    // Memory connection logic.
    generate
        for (i = 0; i < mems; i = i + 1) begin
            assign mem_ports[i].re    = target[i] && cpu_port.re;
            assign mem_ports[i].we    = target[i] && cpu_port.we;
            assign mem_ports[i].asize = cpu_port.asize;
            assign mem_ports[i].addr  = cpu_port.addr;
            assign mem_ports[i].wdata = cpu_port.wdata;
        end
    endgenerate
    
    logic           masked_ready[mems];
    logic           masked_error[mems];
    logic[dlen-1:0] masked_rdata[mems];
    generate
        for (i = 0; i < mems; i = i + 1) begin
            assign masked_ready[i] = target[i] && mem_ports[i].ready;
            assign masked_error[i] = target[i] && mem_ports[i].error;
            assign masked_rdata[i] = target[i] ?  mem_ports[i].rdata : 0;
        end
    endgenerate
    
    always @(*) begin
        integer i;
        if (target == 0) begin
            cpu_port.ready = 1;
            cpu_port.error = 1;
            cpu_port.rdata = `AXO_MEM_EMISSING;
        end else begin
            cpu_port.ready = 0;
            cpu_port.error = 0;
            cpu_port.rdata = 0;
            for (i = 0; i < mems; i = i + 1) begin
                cpu_port.ready |= masked_ready[i];
                cpu_port.error |= masked_error[i];
                cpu_port.rdata |= masked_rdata[i];
            end
        end
    end
endmodule



// Configurable Axo memory bus crossbar.
// Any MEM occupies a NAPOT range at least 4 bytes large in the address space.
// No two MEMs may overlap.
module axo_mem_xbar#(
    // Data width, powers of 2 >= 32.
    parameter integer   dlen = 32,
    // Address width.
    parameter integer   alen = 32,
    
    // Number of CPU to crossbar ports, at least 2.
    parameter integer   cpus = 2,
    // Number of crossbar to MEM ports, at least 2.
    parameter integer   mems = 2
)(
    // Shared clock.
    input logic clk,
    // Shared reset.
    input logic rst,
    
    // CPU to crossbar ports.
    axo_mem_bus.MEM cpu_ports[cpus],
    // Crossbar to MEM ports.
    axo_mem_bus.CPU mem_ports[mems],
    
    // Memory base addresses.
    input logic[alen-1:0] bases[mems],
    // Log2 of memory size.
    input logic[alen-1:0] sizes[mems]
);
    genvar x, y;
    
    // Interconnect helper.
    axo_mem_bus mem_interconnect[mems*cpus]();
    
    // Generate multiplexers.
    generate
        for (x = 0; x < cpus; x = x + 1) begin
            // Instantiate multiplexers.
            axo_mem_bus#(dlen,alen) cpu_to_interconnect[mems]();
            axo_mem_mux#(dlen,alen,mems) mux(clk, rst, cpu_ports[x], cpu_to_interconnect, bases, sizes);
            // Route to interconnect.
            for (y = 0; y < mems; y = y + 1) begin
                assign mem_interconnect[y*cpus+x].re    = cpu_to_interconnect[y].re;
                assign mem_interconnect[y*cpus+x].we    = cpu_to_interconnect[y].we;
                assign mem_interconnect[y*cpus+x].asize = cpu_to_interconnect[y].asize;
                assign mem_interconnect[y*cpus+x].addr  = cpu_to_interconnect[y].addr;
                assign mem_interconnect[y*cpus+x].wdata = cpu_to_interconnect[y].wdata;
                assign cpu_to_interconnect[y].ready     = mem_interconnect[y*cpus+x].ready;
                assign cpu_to_interconnect[y].error     = mem_interconnect[y*cpus+x].error;
                assign cpu_to_interconnect[y].rdata     = mem_interconnect[y*cpus+x].rdata;
            end
        end
    endgenerate
    
    // Generate demultiplexers.
    generate
        for (y = 0; y < mems; y = y + 1) begin
            // Instantiate multiplexers.
            axo_mem_bus#(dlen,alen) mem_to_interconnect[cpus]();
            axo_mem_demux#(dlen,alen,cpus) demux(clk, rst, mem_to_interconnect, mem_ports[y]);
            // Route to interconnect.
            for (x = 0; x < cpus; x = x + 1) begin
                assign mem_to_interconnect[x].re        = mem_interconnect[y*cpus+x].re;
                assign mem_to_interconnect[x].we        = mem_interconnect[y*cpus+x].we;
                assign mem_to_interconnect[x].asize     = mem_interconnect[y*cpus+x].asize;
                assign mem_to_interconnect[x].addr      = mem_interconnect[y*cpus+x].addr;
                assign mem_to_interconnect[x].wdata     = mem_interconnect[y*cpus+x].wdata;
                assign mem_interconnect[y*cpus+x].ready = mem_to_interconnect[x].ready;
                assign mem_interconnect[y*cpus+x].error = mem_to_interconnect[x].error;
                assign mem_interconnect[y*cpus+x].rdata = mem_to_interconnect[x].rdata;
            end
        end
    endgenerate
endmodule
