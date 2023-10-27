`timescale 1ns/1ps
`include "axo_defines.sv"

module top(
    input wire clk
);
    reg [15:0]  irq = 0;
    wire        ready;
    
    // unaligned_ram#(32, 256) ram(clk, mem_re, mem_we, mem_asize, mem_addr, mem_wdata, mem_rdata);
    
    wire        prog_re;
    wire[31:1]  prog_addr;
    wire        prog_ready;
    wire        prog_error;
    wire[31:0]  prog_data;
    
    axo_mem_bus mem_port();
    insn_rom irom(mem_port);
    
    axo_mem_bus cpu_ports[2]();
    
    axo_mem_demux#(32, 32, 2) mux(
        clk, 0,
        cpu_ports,
        mem_port
    );
    
    axo_rv32im_zicsr#(0) cpu(
        clk, 1'b0, 1'b0, ready,
        cpu_ports[0], cpu_ports[1],
        irq
    );
    
    reg[15:0] irq_timer = 0;
    always @(posedge clk) begin
        if (mem_port.addr == 256) begin
            $write("%s", mem_port.wdata[7:0]);
        end
        irq_timer <= irq_timer + 1;
        if (irq_timer >= 25) begin
            irq <= 16'hffff;
        end
    end
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
