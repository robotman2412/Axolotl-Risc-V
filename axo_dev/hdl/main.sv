
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps

module main(
    (* mark_debug = "true" *)
    input  logic    clk_fast,
    (* mark_debug = "true" *)
    input  logic    rst
);
    `include "axo_functions.sv"
    
    reg clk_slow = 0;
    always @(posedge clk_fast) begin
        clk_slow <= !clk_slow;
    end
    
    axo_mem_bus bus();
    aligned_ram#(.init_file({axo_parentdir(`__FILE__), "/../build/rom.mem"})) ram(clk_fast, clk_slow, bus);
    
    reg[7:0] cycle;
    always @(posedge clk_slow) begin
        cycle <= rst ? 0 : cycle + 1;
    end
    
    always @(*) begin
        case (cycle)
            default: begin bus.re = 0; bus.we = 0; bus.asize = 0; bus.addr = 32'h0000_0000; bus.wdata = 32'h0000_0000; end
            // ?: begin bus.re = 0; bus.we = 0; bus.asize = 0; bus.addr = 32'h0000_0000; bus.wdata = 32'h0000_0000; end
            
            2:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_0000; bus.wdata = 32'h0000_0000; end
            3:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_0004; bus.wdata = 32'h0000_0000; end
            4:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_0008; bus.wdata = 32'h0000_0000; end
            5:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_000C; bus.wdata = 32'h0000_0000; end
            6:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_0010; bus.wdata = 32'h0000_0000; end
            7:  begin bus.re = 1; bus.we = 0; bus.asize = 2; bus.addr = 32'h0000_0014; bus.wdata = 32'h0000_0000; end
        endcase
    end
endmodule
