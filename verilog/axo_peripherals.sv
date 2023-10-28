
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps
`include "axo_defines.sv"

// Peripheral bus: A subset of the standard Axo bus.
interface axo_peri_bus#(
    // Address width.
    parameter       alen = 12
);
    // CPU -> MEM: Read enable.
    logic           re;
    // CPU -> MEM: Write enable.
    logic           we;
    // CPU -> MEM: Register address / index.
    logic[alen-1:0] addr;
    // CPU -> MEM: Write data.
    logic[31:0]     wdata;
    
    // MEM -> CPU: Ready to transfer.
    logic           ready;
    // MEM -> CPU: Read data.
    logic[31:0]     rdata;
    
    // Directions from CPU perspective.
    modport CPU (output re, we, addr, wdata, input ready, rdata);
    // Directions from MEM perspective.
    modport MEM (output ready, rdata, input re, we, addr, wdata);
endinterface



// Axo memory bus to peripheral bus bridge / adapter.
module axo_mem_peri_bridge#(
    // Address width.
    parameter integer   alen = 32
)(
    // CPU to demultiplexer ports.
    axo_mem_bus.MEM cpu_port,
    // Demultiplexer to MEM port.
    axo_peri_bus.CPU mem_port
);
    assign mem_port.addr    = cpu_port.addr >> 2;
    assign mem_port.re      = valid && cpu_port.re;
    assign mem_port.we      = valid && cpu_port.we;
    assign mem_port.wdata   = cpu_port.wdata;
    
    logic valid;
    always @(*) begin
        if (cpu_port.asize != 2) begin
            cpu_port.ready  = 1;
            cpu_port.error  = 1;
            cpu_port.rdata  = `AXO_MEM_EASIZE;
            valid           = 0;
        end else if (cpu_port.addr[1:0] != 0) begin
            cpu_port.ready  = 1;
            cpu_port.error  = 1;
            cpu_port.rdata  = `AXO_MEM_EALIGN;
            valid           = 0;
        end else begin
            cpu_port.ready  = mem_port.ready;
            cpu_port.error  = 0;
            cpu_port.rdata  = mem_port.rdata;
            valid = 1;
        end
    end
endmodule

// Axo memory bus to peripheral bus bridge / demultiplexer.
module axo_mem_peri_demux#(
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
    axo_peri_bus.CPU mem_ports[mems],
    
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
            assign mem_ports[i].addr  = cpu_port.addr >> 2;
            assign mem_ports[i].wdata = cpu_port.wdata;
        end
    endgenerate
    
    logic           masked_ready[mems];
    logic[31:0] masked_rdata[mems];
    generate
        for (i = 0; i < mems; i = i + 1) begin
            assign masked_ready[i] = target[i] && mem_ports[i].ready;
            assign masked_rdata[i] = target[i] ?  mem_ports[i].rdata : 0;
        end
    endgenerate
    
    always @(*) begin
        integer i;
        if (target == 0) begin
            cpu_port.ready = 1;
            cpu_port.error = 1;
            cpu_port.rdata = `AXO_MEM_EMISSING;
        end else if (cpu_port.asize != 2) begin
            cpu_port.ready = 1;
            cpu_port.error = 1;
            cpu_port.rdata = `AXO_MEM_EASIZE;
        end else if (cpu_port.addr & 3) begin
            cpu_port.ready = 1;
            cpu_port.error = 1;
            cpu_port.rdata = `AXO_MEM_EALIGN;
        end else begin
            cpu_port.ready = 0;
            cpu_port.error = 0;
            cpu_port.rdata = 0;
            for (i = 0; i < mems; i = i + 1) begin
                cpu_port.ready |= masked_ready[i];
                cpu_port.rdata |= masked_rdata[i];
            end
        end
    end
endmodule



// Basic GPIO module.
module axo_peri_gpio#(
    // Number of I/O pins per bank.
    parameter num_pins      = 32,
    // Output direction polarity, 0: active-high, 1: active-low.
    parameter invert_oe     = 0,
    // Pin polarity, 0: active-high, 1: active-low.
    parameter invert_level  = 0
)(
    // Peripheral bus clock.
    input  logic                clk,
    // Peripheral bus interface.
    axo_peri_bus.MEM            bus,
    // I/O pin banks.
    inout  wire[num_pins-1:0]   pins
);
    // I/O direction registers.
    reg  [num_pins-1:0] iodir;
    // I/O output registers.
    reg  [num_pins-1:0] iolevel;
    // I/I input registers.
    logic[num_pins-1:0] iosense;
    
    generate
        genvar i;
        for (i = 0; i < num_pins; i = i + 1) begin
            assign pins[i]    = iodir ^ invert_oe ? iolevel[i] ^ invert_level : 'bz;
            assign iosense[i] = iodir ^ invert_oe ? iolevel[i] : pins[i] ^ invert_level;
        end
    endgenerate
    
    assign bus.ready = 1;
    always @(*) begin
        if (!bus.addr[0]) begin
            bus.rdata = iodir;
        end else begin
            bus.rdata = iosense;
        end
    end
    
    always @(posedge clk) begin
        if (!bus.addr[0] && bus.we) begin
            iodir   <= bus.wdata;
        end else if (bus.addr[0] && bus.we) begin
            iolevel <= bus.wdata;
        end
    end
endmodule
