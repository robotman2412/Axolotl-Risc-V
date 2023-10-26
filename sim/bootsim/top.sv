`timescale 1ns/1ns

module top(
    input wire clk
);
    reg [15:0]  irq = 0;
    wire        ready;
    
    wire        mem_re;
    wire        mem_we;
    wire[1:0]   mem_asize;
    wire[31:0]  mem_addr;
    wire[31:0]  mem_wdata;
    wire        mem_ready;
    wire        mem_error;
    wire[31:0]  mem_rdata;
    // unaligned_ram#(32, 256) ram(clk, mem_re, mem_we, mem_asize, mem_addr, mem_wdata, mem_rdata);
    
    wire        prog_re;
    wire[31:1]  prog_addr;
    wire        prog_ready;
    wire        prog_error;
    wire[31:0]  prog_data;
    
    axo_mem_bus mem_port();
    insn_rom irom(mem_port.addr, mem_port.rdata);
    assign mem_port.error = mem_port.addr & 1;
    assign mem_port.ready = 1;
    
    axo_mem_bus cpu_ports[2]();
    assign cpu_ports[0].re    = prog_re;
    assign cpu_ports[0].we    = 0;
    assign cpu_ports[0].asize = 2;
    assign cpu_ports[0].addr  = prog_addr;
    assign cpu_ports[0].wdata = 0;
    
    assign prog_ready = cpu_ports[0].ready;
    assign prog_error = cpu_ports[0].error;
    assign prog_data  = cpu_ports[0].rdata;
    
    assign cpu_ports[1].re    = mem_re;
    assign cpu_ports[1].we    = mem_we;
    assign cpu_ports[1].asize = mem_asize;
    assign cpu_ports[1].addr  = mem_addr;
    assign cpu_ports[1].wdata = mem_wdata;
    
    assign mem_ready = cpu_ports[1].ready;
    assign mem_error = cpu_ports[1].error;
    assign mem_rdata = cpu_ports[1].rdata;
    
    axo_mem_demux#(32, 32, 2) mux(
        clk, 0,
        cpu_ports,
        mem_port
    );
    
    axo_rv32im_zicsr#(0) cpu(
        clk, 1'b0, 1'b0, ready,
        mem_re, mem_we, mem_asize, mem_addr, mem_wdata, mem_ready, mem_error, mem_rdata,
        prog_re, prog_addr, prog_ready, prog_error, prog_data,
        irq
    );
    
    reg[15:0] irq_timer = 0;
    always @(posedge clk) begin
        if (mem_addr == 255) begin
            $write("%s", mem_wdata[7:0]);
        end
        irq_timer <= irq_timer + 1;
        if (irq_timer >= 25) begin
            irq <= 16'hffff;
        end
    end
endmodule

module insn_rom(
    input  wire[31:1] addr,
    output wire[31:0] data
);
    `include "obj_dir/rom.sv"
    assign data[15:0]  = rom[addr >> 1];
    assign data[31:16] = rom[(addr >> 1) + 1];
endmodule
