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
    // RAM and ROM.
    wire[31:0] rom_data_raw;
    wire[31:0] rom_addr_raw;
    wire[12:0] ram_addr;
    wire[7:0]  ram_data_in;
    wire[7:0]  ram_data_out;
    wire       ram_we;
                         /* ROM */     /* RAM */
    the_ram_wrapper mem (rom_addr_raw, ram_addr,
                         GCLK,         GCLK,
                                       ram_data_in,
                         rom_data_raw, ram_data_out,
                         1 /*enable*/, 1 /*enable*/,
                         0 /*reset*/,  0 /*reset*/,
                         rom_rst_busy, ram_rst_busy,
                                       ram_we);
    
    wire[7:0]  rom_data;
    wire[10:0] rom_addr;
    
    assign rom_addr_raw = rom_addr;
    assign rom_data     = (rom_addr[1:0] == 0) ? rom_data_raw[7:0]   :
                          (rom_addr[1:0] == 1) ? rom_data_raw[15:8]  :
                          (rom_addr[1:0] == 2) ? rom_data_raw[23:16] :
                          rom_data_raw[31:24];
    
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
    localparam tty_idle   =  0;
    localparam tty_char   =  1;
    localparam tty_wrap   =  2;
    localparam tty_lf     =  3;
    localparam tty_bksp   =  4;
    
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
    
    // TTY functionality.
    reg[13:0]  char_disp_pos_reg;
    reg[13:0]  char_set_pos;
    reg[7:0]   char_set_x;
    reg[7:0]   char_set_y;
    reg[3:0]   tty_state;
    wire[7:0]  tty_input    = SW;
    assign     ram_data_in  = SW;
    assign     ram_we       = tty_state == tty_char && pos_x == h_sync_on-1;
    
    wire[13:0] char_disp_pos = char_x + char_disp_pos_reg;
    
//    assign red  [3]   = SW[7];
//    assign green[3]   = SW[7];
//    assign blue [3]   = SW[7];
//    assign red  [0]   = SW[0];
//    assign green[0]   = SW[0];
//    assign blue [0]   = SW[0];
    
//    assign red  [2:1] = SW[6:5];
//    assign green[2:1] = SW[4:3];
//    assign blue [2:1] = SW[2:1];
    
    assign     VGA_HS     = ~h_sync;
    assign     VGA_VS     = ~v_sync;
    assign     VGA_R      = vid_enable ? red   : 0;
    assign     VGA_G      = vid_enable ? green : 0;
    assign     VGA_B      = vid_enable ? blue  : 0;
    
    wire       bit        = rom_data[pos_y[2:0]];
    wire       inv        = frame_ctr[5] && char_disp_pos == char_set_pos;
    assign     red        = bit ^ inv ? 3  : 0;
    assign     green      = bit ^ inv ? 15 : 0;
    assign     blue       = bit ^ inv ? 3  : 0;
    
    // Haha, HEX.
    wire[10:0] hex_src    = char_x == 0 ? char_y : char_x;
    wire       hex_x      = (char_x  >= 2  && char_x < 18);
    wire       hex_y      = (char_y  >= 2  && char_y < 18);
    wire[7:0]  tha_hex    = (hex_src < 12) ? hex_src - 2 + 'h30 : hex_src - 12 + 'h41;
    wire[7:0]  get_hex    = (hex_x && hex_y)       ? ((char_x - 2) & 15) | (((char_y - 2) & 15) << 4) :
                            (hex_x && char_y == 0) ? tha_hex :
                            (hex_y && char_x == 0) ? tha_hex :
                            'h20;
    // HaHa, CHAR.
    wire[7:0]  char       = BTNU ? get_hex : 
                            (char_x == char_set_x && char_y == char_set_y) ? SW :
                            ram_data_out;
    assign rom_addr[2:0]  = pos_x[2:0];
    assign rom_addr[10:3] = char;
    assign ram_addr       = vid_enable ? char_disp_pos : char_set_pos;
    
    reg    prev_BTNC;
    
    initial begin
        // Reset.
        clk_div           = 0;
        // VGA signalgeneration.
        frame_ctr         = 0;
        pos_x             = 0;
        pos_y             = 0;
        h_vid_enable      = 0;
        v_vid_enable      = 0;
        h_sync            = 0;
        v_sync            = 0;
        // TTY functionality.
        char_disp_pos_reg = 0;
        char_set_pos      = 0;
        char_set_x        = 0;
        char_set_y        = 0;
        tty_state         = 0;
    end
    
    always @(posedge GCLK) begin
//        if (tty_input == 'h0A || tty_input == 'h0D) begin
//            // Line feed.
//            //tty_state = tty_lf;
//        end else if (tty_input == 'h7F) begin
//            // Backspace.
//            //tty_state = tty_bksp;
//        end else if (tty_input != 'h00) begin
//            // Add the char.
//            if (char_set_x == n_char_x) begin
//                // And line-wrap.
//                //tty_state = tty_wrap;
//            end else begin
//                // No line-wrap.
//                tty_state = tty_char;
//            end
//        end
        if (BTNC & ~prev_BTNC) begin
            tty_state = tty_char;
        end
        
        clk_div = clk_div + 1;
        if (clk_div == 2 || clk_div == 5) begin
            pos_x = pos_x + 1;
            if (pos_x == h_vid_off) begin
                // Front proch starts.
                h_vid_enable = 0;
            end else if (pos_x == h_sync_on) begin
                // Sync starts.
                h_sync = 1;
                
                if (tty_state == tty_char) begin
                    // Put char.
                    char_set_x   = char_set_x + 1;
                    char_set_pos = char_set_pos + 1;
                    tty_state    = tty_idle;
                end
            end else if (pos_x == h_sync_off) begin
                // Sync ends.
                h_sync = 0;
            end else if (pos_x == h_limit) begin
                // Next line starts.
                h_vid_enable = 1;
                pos_x = 0;
                if (pos_y == v_limit - 1) begin
                    char_disp_pos_reg = 0;
                end else if (pos_y[2:0] == 7) begin
                    char_disp_pos_reg = char_disp_pos_reg + n_char_x;
                end
            end
        end
        if (clk_div == 5) begin
            clk_div = 0;
        end
        prev_BTNC = BTNC;
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




