`timescale 1ns / 1ps

//////////
// HAHA //
//////////

module top(
    output wire[3:0] VGA_R,
    output wire[3:0] VGA_G,
    output wire[3:0] VGA_B,
    output wire      VGA_VS,
    output wire      VGA_HS,
    input  wire      GCLK,
    input  wire      BTNC,
    input  wire      BTND,
    input  wire      BTNL,
    input  wire      BTNR,
    input  wire      BTNU,
    input  wire[7:0] SW,
    output wire[7:0] LED
);
    // Horizontal timing parameters.
    localparam h_vid_off  =  800;
    localparam h_sync_on  =  840;
    localparam h_sync_off =  968;
    localparam h_limit    = 1056;
    // Vertical timing parameters.
    localparam v_vid_off  =  600;
    localparam v_sync_on  =  601;
    localparam v_sync_off =  605;
    localparam v_limit    =  628;
    // TTY parameters.
    localparam n_char_x   =  100;
    localparam n_char_y   =  75;
    
    // VGA signal generation.
    reg[31:0] frame_ctr;
    reg[3:0]  clk_div;
    reg[10:0] pos_x;
    reg[9:0]  pos_y;
    wire[7:0] char_x = pos_x[10:3];
    wire[6:0] char_y = pos_y[9:3];
    reg       h_sync;
    reg       v_sync;
    reg       h_vid_enable;
    reg       v_vid_enable;
    wire      vid_enable = h_vid_enable & v_vid_enable;
    
    wire[3:0] red;
    wire[3:0] green;
    wire[3:0] blue;
    
    assign     VGA_HS     = ~h_sync;
    assign     VGA_VS     = ~v_sync;
    assign     VGA_R      = vid_enable ? red   : 0;
    assign     VGA_G      = vid_enable ? green : 0;
    assign     VGA_B      = vid_enable ? blue  : 0;
    
    assign     red        = pos_x;
    assign     green      = pos_x>>2;
    assign     blue       = pos_y;
    
    initial begin
        // Reset.
        clk_div           = 0;
        // VGA signal generation.
        frame_ctr         = 0;
        pos_x             = 0;
        pos_y             = 0;
        h_vid_enable      = 0;
        v_vid_enable      = 0;
        h_sync            = 0;
        v_sync            = 0;
    end
    
    always @(posedge GCLK) begin
        clk_div = clk_div + 1;
        if (clk_div == 2 || clk_div == 5) begin
            pos_x = pos_x + 1;
            if (pos_x == h_vid_off) begin
                // Front proch starts.
                h_vid_enable = 0;
            end else if (pos_x == h_sync_on) begin
                // Sync starts.
                h_sync = 1;
            end else if (pos_x == h_sync_off) begin
                // Sync ends.
                h_sync = 0;
            end else if (pos_x == h_limit) begin
                // Next line starts.
                h_vid_enable = 1;
                pos_x = 0;
            end
        end
        if (clk_div == 5) begin
            clk_div = 0;
        end
    end
    
    always @(posedge h_vid_enable) begin
        // Do the vertical.
        pos_y = pos_y + 1;
        if (pos_y == v_vid_off) begin
            // Front proch starts.
            v_vid_enable = 0;
        end else if (pos_y == v_sync_on) begin
            // Sync starts.
            v_sync = 1;
        end else if (pos_y == v_sync_off) begin
            // Sync ends.
            v_sync = 0;
        end else if (pos_y == v_limit) begin
            // Next frame starts.
            v_vid_enable = 1;
            pos_y = 0;
            frame_ctr = frame_ctr + 1;
        end
    end
    
endmodule
