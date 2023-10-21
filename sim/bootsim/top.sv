`timescale 1ns/1ns

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
    wire[31:0]  prog_addr;
    //                          [   imm    ] [rs1]     [rd ] [op ]
    wire[31:0]  prog_data = 32'b000000000011_00001_000_00001_0010011;
    
    axo_rv32im_zicsr cpu(
        clk, 1'b0, 1'b0, ready,
        mem_re, mem_we, mem_asize, mem_ready, mem_addr, mem_data,
        prog_re, prog_ready, prog_addr, prog_data
    );
    
    integer i;
    initial begin
        $dumpfile("build/sim.vcd");
        $dumpvars(0, top);
        
        for (i = 0; i < 10; i = i + 1) begin
            #10 clk <= 1;
            #10 clk <= 0;
        end
    end
endmodule