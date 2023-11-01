`timescale 1ns/1ps
`include "axo_defines.sv"

module top(
    input  wire clk,
    output wire txd
);
    wire[15:0]  irq;
    wire        ready;
    
    wire rst = 0;
    
    reg[8:0] rxsample = 8'b0011_0101;
    reg[1:0] rxdiv = 0;
    reg rxd = 1;
    
    // unaligned_ram#(32, 256) ram(clk, mem_re, mem_we, mem_asize, mem_addr, mem_wdata, mem_rdata);
    
    wire        prog_re;
    wire[31:1]  prog_addr;
    wire        prog_ready;
    wire        prog_error;
    wire[31:0]  prog_data;
    
    axo_mem_bus mem_ports[2]();
    insn_rom irom(mem_ports[0]);
    
    axo_peri_bus pbus();
    axo_mem_peri_bridge bridge(mem_ports[1], pbus);
    wire rxd_full;
    wire txd_empty;
    axo_peri_uart#(4, 4, 1) uart(clk, rst, pbus, clk, txd, rxd, rxd_full, txd_empty);
    assign irq[15:1] = 0;
    assign irq[0]    = rxd_full;
    // wire[31:0] gpio_wires;
    // axo_peri_gpio gpio(clk, pbus, gpio_wires);
    
    always @(posedge clk) begin
        rxdiv <= rxdiv + 1;
        if (rxdiv == 0) begin
            rxd <= rxsample[8];
            rxsample[8:1] <= rxsample[7:0];
            rxsample[0]   <= 1;
        end
    end
    
    axo_mem_bus cpu_ports[2]();
    
    axo_mem_xbar#(32, 32, 2, 2) xbar(
        clk, 0,
        cpu_ports,
        mem_ports,
        '{0, 256},
        '{8, 8}
    );
    
    axo_rv32im_zicsr#(.entrypoint(0)) cpu(
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
