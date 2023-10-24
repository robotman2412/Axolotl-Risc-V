`timescale 1ns/1ns

module top(
    input wire clk
);
    reg [15:0]  irq = 0;
    wire        ready;
    
    wire        mem_re;
    wire        mem_we;
    wire[1:0]   mem_asize;
    wire        mem_ready = 1;
    wire[31:0]  mem_addr;
    wire[31:0]  mem_data;
    unaligned_ram#(32, 256) ram(clk, mem_re, mem_we, mem_asize, mem_addr, mem_data);
    
    wire        prog_re;
    wire        prog_ready = 1;
    wire[31:1]  prog_addr;
    wire[31:0]  prog_data;
    insn_rom irom(prog_addr, prog_data);
    
    axo_rv32im_zicsr#(0) cpu(
        clk, 1'b0, 1'b0, ready,
        mem_re, mem_we, mem_asize, mem_ready, mem_addr, mem_data,
        prog_re, prog_ready, prog_addr, prog_data,
        irq
    );
    
    reg[15:0] irq_timer = 0;
    always @(posedge clk) begin
        if (mem_addr == 255) begin
            $write("%s", mem_data[7:0]);
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
