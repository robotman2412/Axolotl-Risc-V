`timescale 1ns/1ps


module top(
    input wire clk
);
    axo_mem_bus cpus[4]();
    axo_mem_bus mems[4]();
    
    assign mems[0].ready = 1;
    assign mems[0].error = 0;
    assign mems[0].rdata = 32'hdeadbeef;
    
    assign mems[1].ready = 1;
    assign mems[1].error = 0;
    assign mems[1].rdata = 32'hf00dbabe;
    
    assign mems[2].ready = 1;
    assign mems[2].error = 0;
    assign mems[2].rdata = 32'hbaadf00d;
    
    assign mems[3].ready = 1;
    assign mems[3].error = 0;
    assign mems[3].rdata = 32'hcafebabe;
    
    reg rst = 1;
    
    always @(posedge clk) rst <= 0;
    
    axo_mem_xbar#(.dlen(32), .alen(32), .cpus(4), .mems(4))
    xbar(clk, rst, cpus, mems, '{0, 4, 16, 32}, '{2, 2, 4, 2});
    
    assign cpus[0].re    = 1;
    assign cpus[0].we    = 0;
    assign cpus[0].asize = 0;
    assign cpus[0].wdata = 0;
    
    assign cpus[1].re    = 1;
    assign cpus[1].we    = 0;
    assign cpus[1].asize = 0;
    assign cpus[1].wdata = 0;
    
    assign cpus[2].re    = 1;
    assign cpus[2].we    = 0;
    assign cpus[2].asize = 0;
    assign cpus[2].wdata = 0;
    
    assign cpus[3].re    = 1;
    assign cpus[3].we    = 0;
    assign cpus[3].asize = 0;
    assign cpus[3].wdata = 0;
    
    initial begin
        cpus[0].addr = 0;
        cpus[1].addr = 2;
        cpus[2].addr = 3;
        cpus[3].addr = 4;
    end
    always @(posedge clk) begin
        cpus[0].addr <= cpus[0].addr + cpus[0].ready;
        cpus[1].addr <= cpus[1].addr + cpus[1].ready;
        cpus[2].addr <= cpus[2].addr + cpus[2].ready;
        cpus[3].addr <= cpus[3].addr + cpus[3].ready;
    end
endmodule
