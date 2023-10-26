
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

// 8-bit RAM that can be accessed as 16- and 32-bit RAM without alignment.
module unaligned_ram #(
    // Width of addres bus.
    parameter addr_width = 4,
    // Amount of 8-bit words.
    parameter depth = 16
)(
    // Write synchronisation.
    input wire clk,
    
    // Read enable.
    input wire re,
    // Write enable.
    input wire we,
    
    // Access width in 2^n bytes.
    input  wire[1:0] asize,
    // Address.
    input  wire[addr_width-1:0] addr,
    // Write data.
    input  wire[31:0] wdata,
    // Read data.
    output wire[31:0] rdata
);
    // Internal storage.
    reg[7:0] storage[depth-1:0];
    
    // Read logic.
    assign rdata[7:0]   = !re ? 'bz : storage[addr];
    assign rdata[15:8]  = !re || asize < 1 ? 'bz : storage[addr+1];
    assign rdata[23:16] = !re || asize < 2 ? 'bz : storage[addr+2];
    assign rdata[31:24] = !re || asize < 2 ? 'bz : storage[addr+3];
    
    integer i;
    initial begin
        for (i = 0; i < depth; i = i + 1) begin
            storage[i] = 0;
        end
    end
    
    always @(posedge clk) begin
        // Write logic.
        if (we) begin
            storage[addr] <= wdata[7:0];
        end
        if (we && asize >= 1) begin
            storage[addr+1] <= wdata[15:8];
        end
        if (we && asize >= 2) begin
            storage[addr+2] <= wdata[23:16];
            storage[addr+3] <= wdata[31:24];
        end
    end
endmodule



// 32-bit RAM that can be accessed as 8- and 16-bit RAM with correct alignment.
module aligned_ram #(
    // Width of addres bus.
    parameter addr_width = 4,
    // Amount of 32-bit words.
    parameter depth = 16
)(
    // Write synchronisation.
    input wire clk,
    
    // Read enable.
    input wire re,
    // Write enable.
    input wire we,
    
    // Access width in 2^n bytes.
    input  wire[1:0] asize,
    // Address.
    input  wire[addr_width-1:0] addr,
    // Write data.
    inout  wire[31:0] wdata,
    // Read data.
    output wire[31:0] rdata,
    
    // Misalignment error.
    output wire alignerr
);
    // Internal storage.
    reg[31:0] storage[depth-1:0];
    
    // Read logic.
    logic[31:0] dout;
    assign rdata = re ? dout : 'bz;
    
    integer i;
    initial begin
        // Init RAM to zero.
        for (i = 0; i < depth; i=i+1) begin
            storage[i] = 0;
        end
    end
    
    always @(*) begin
        // Read logic.
        if (asize == 0) begin
            // 8-bit read.
            if (addr[1:0] == 0) begin
                dout[7:0] <= storage[addr>>2][7:0];
            end else if (addr[1:0] == 1) begin
                dout[7:0] <= storage[addr>>2][15:8];
            end else if (addr[1:0] == 2) begin
                dout[7:0] <= storage[addr>>2][23:16];
            end else if (addr[1:0] == 3) begin
                dout[7:0] <= storage[addr>>2][31:24];
            end
            dout[31:8] <= 0;
            
        end else if (asize == 1) begin
            // 16-bit read.
            if (addr[1] == 0) begin
                dout[15:0] <= storage[addr>>2][15:0];
            end else begin
                dout[15:0] <= storage[addr>>2][31:16];
            end
            dout[31:16] <= 0;
            
        end else if (asize == 2) begin
            // 32-bit read.
            dout <= storage[addr>>2];
            
        end else begin
            // Dummy.
            dout <= 0;
        end
    end
    
    // Alignment checking logic.
    assign alignerr = !(we | re) ? 0
                    : asize == 0 ? 0
                    : asize == 1 ? addr[0]
                    : asize == 2 ? addr[1] | addr[0]
                    : 1;
    
    always @(posedge clk) begin
        // Write logic.
        if (we && asize == 0) begin
            $display("sb [0x%08h] = 0x%08h", addr, wdata);
            // 8-bit write.
            if (addr[1:0] == 0) begin
                storage[addr>>2][7:0] = wdata[7:0];
            end else if (addr[1:0] == 1) begin
                storage[addr>>2][15:8] = wdata[7:0];
            end else if (addr[1:0] == 2) begin
                storage[addr>>2][23:16] = wdata[7:0];
            end else if (addr[1:0] == 3) begin
                storage[addr>>2][31:24] = wdata[7:0];
            end
            
        end else if (we && asize == 1) begin
            $display("sh [0x%08h] = 0x%08h", addr, wdata);
            // 16-bit write.
            if (addr[1]) begin
                storage[addr>>2][31:16] = wdata[15:0];
            end else begin
                storage[addr>>2][15:0] = wdata[15:0];
            end
            
        end else if (we && asize == 2) begin
            $display("sw [0x%08h] = 0x%08h", addr, wdata);
            // 32-bit write.
            storage[addr>>2] <= wdata;
        end
    end
endmodule
