`timescale 1ns/1ns

module insn_rom(
    input  wire[31:1] addr,
    output wire[31:0] data
);
    `include "build/rom.sv"
    assign data[15:0]  = rom[addr >> 1];
    assign data[31:16] = rom[(addr >> 1) + 1];
endmodule

module top(
);
    reg         clk = 0;
    wire        ready;
    
    wire        mem_re;
    wire        mem_we;
    wire[1:0]   mem_asize;
    wire        mem_ready = 0;
    wire[31:0]  mem_addr;
    wire[31:0]  mem_data;
    
    wire        prog_re;
    wire        prog_ready = 1;
    wire[31:1]  prog_addr;
    wire[31:0]  prog_data;
    insn_rom rom(prog_addr, prog_data);
    
    axo_rv32im_zicsr#(0) cpu(
        clk, 1'b0, 1'b0, ready,
        mem_re, mem_we, mem_asize, mem_ready, mem_addr, mem_data,
        prog_re, prog_ready, prog_addr, prog_data
    );
    
    integer i;
    initial begin
        $dumpfile("build/sim.vcd");
        $dumpvars(0, top);
        
        for (i = 0; i < 50; i = i + 1) begin
            #10 clk <= 1;
            #10 clk <= 0;
        end
    end
endmodule