
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ps

module main(
    (* mark_debug = "true" *)
    input  logic    clk,
    (* mark_debug = "true" *)
    input  logic    rst
);
    (* mark_debug = "true" *)
    logic[3:0] we;
    (* mark_debug = "true" *)
    logic[4:0] addr;
    (* mark_debug = "true" *)
    logic[31:0] wdata;
    (* mark_debug = "true" *)
    logic[31:0] rdata;
    
    raw_block_ram#(.abits(5), .write_first(0)) bram(clk, we, addr, wdata, rdata);
    
    reg[7:0] cycle = 0;
    always @(negedge clk) begin
        if (rst) begin
            cycle <= 0;
        end else begin
            cycle <= cycle + 1;
        end
    end
    
    always @(*) begin
        case (cycle)
            default: begin we = 4'b0000; addr = 5'h00; wdata = 32'h0000_0000; end
            1: begin we = 4'b1111; addr = 5'h00; wdata = 32'hdead_beef; end
            2: begin we = 4'b1001; addr = 5'h01; wdata = 32'hdead_beef; end
            3: begin we = 4'b0011; addr = 5'h0f; wdata = 32'hf00d_babe; end
            4: begin we = 4'b1100; addr = 5'h0f; wdata = 32'hf00d_babe; end
        endcase
    end
endmodule
