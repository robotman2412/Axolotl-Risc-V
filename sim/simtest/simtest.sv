`timescale 1ns/1ns

module gamma(
    input wire clk,
    input wire[3:0] d
);
    reg[3:0] r = 0;
    always @(posedge clk) begin
        #1 r <= d;
    end
endmodule

module top(
);
    function automatic [0:0] thingy(input[3:0] alpha);
        begin
            thingy = alpha[2];
        end
    endfunction
    
    reg clk;
    reg[3:0] thing;
    gamma y(clk, thing);
    wire lol = thingy(thing);
    wire asdf = thingy(thing ^ 4);
    
    integer i;
    initial begin
        $dumpfile("build/sim.vcd");
        $dumpvars(0, top);
        clk   <= 0;
        thing <= 15;
        
        for (i = 0; i < 16; i = i + 1) begin
            #1  thing <= thing + 1;
            #9  clk <= 1;
            #10 clk <= 0;
        end
    end
endmodule
