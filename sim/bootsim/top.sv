`timescale 1ns/1ps
`include "axo_defines.sv"

module top(
    input wire clk
);
    reg [15:0]  irq = 0;
    wire        ready;
    
    reg rst = 0;
    reg[3:0] delay = 0;
    always @(posedge clk) begin
        if (delay == 15) begin
            rst <= 0;
        end else if (delay == 14) begin
            rst <= 1;
            delay <= delay + 1;
        end else begin
            delay <= delay + 1;
        end
    end
    
    // unaligned_ram#(32, 256) ram(clk, mem_re, mem_we, mem_asize, mem_addr, mem_wdata, mem_rdata);
    
    wire        prog_re;
    wire[31:1]  prog_addr;
    wire        prog_ready;
    wire        prog_error;
    wire[31:0]  prog_data;
    
    axo_mem_bus mem_ports[2]();
    insn_rom irom(mem_ports[0]);
    
    axo_peri_bus pbus();
    wire[31:0] gpio_wires;
    axo_peri_gpio gpio(clk, pbus, gpio_wires);
    axo_mem_peri_bridge bridge(mem_ports[1], pbus);
    
    axo_mem_bus cpu_ports[2]();
    
    axo_mem_xbar#(32, 32, 2, 2) xbar(
        clk, 0,
        cpu_ports,
        mem_ports,
        '{0, 256},
        '{8, 8}
    );
    
    axo_rv32im_zicsr#(.entrypoint(0), .hcf_on_trap(1)) cpu(
        clk, 1'b0, rst, ready,
        cpu_ports[0], cpu_ports[1],
        irq
    );
endmodule

module insn_rom(
    axo_mem_bus bus
);
    `include "obj_dir/rom.sv"
    assign bus.ready = 1;
    always @(*) begin
        // if (bus.we) begin
        //     bus.error = 1;
        //     bus.rdata = `AXO_MEM_READONLY;
        // end else if (bus.re && bus.addr[1:0]) begin
        //     bus.error = 1;
        //     bus.rdata = `AXO_MEM_EALIGN;
        // end else if (bus.re && bus.asize != 2) begin
        //     bus.error = 1;
        //     bus.rdata = `AXO_MEM_EASIZE;
        // end else begin
            bus.error = 0;
            bus.rdata = rom[bus.addr >> 2];
        // end
    end
endmodule
