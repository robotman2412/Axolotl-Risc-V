
`timescale 1ns/1ps

module top(
    input   wire clk,
    output reg delta
);
    initial begin
        delta = 0;
        // $dumpfile("obj_dir/sim.fst");
        // $dumpvars;
    end
    
    always @(posedge clk) begin
        delta <= !delta;
    end
endmodule
