
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns / 1ps
`include "axo_defines.sv"

// Unbuffered UART transmitter.
// Takes a clock that matches baudrate (e.g. 9600 baud means a 9600Hz clock).
module unbuffered_uart_tx(
    input  wire      clk,
    input  wire[7:0] tx_byte,
    input  wire      tx_trig,
    output wire      txd,
    output reg       tx_busy
);
    // Counts number of sent bits.
    reg[4:0]  state;
    // Buffer for sending data.
    reg[10:0] tx_buf;
    // TX data is LSB of TX buffer.
    assign    txd     = tx_buf[0];
    
    initial begin
        state   = 0;
        tx_buf  = 11'h7ff;
        tx_busy = 0;
    end
    
    always @(posedge clk) begin
        if (state == 0 && tx_trig) begin
            // Initialise transmitter state.
            $display("STARTING");
            tx_buf[0]    <= 0;
            tx_buf[8:1]  <= tx_byte;
            tx_buf[10:9] <= 3;
            state        <= 1;
            tx_busy      <= 1;
        end else if (state == 10) begin
            // Finalise transmitter state.
            state   <= 0;
            tx_buf  <= 11'h7ff;
            tx_busy <= 0;
        end else if (state != 0) begin
            // Shift send buffer.
            state  <= state + 1;
            tx_buf <= (tx_buf >> 1) | 11'h400;
        end
    end
endmodule

// Unbuffered UART receiver.
// Takes a clock that is 4x, 2x, 1x baudrate (e.g. 9600 baud means a clk[0]=38400Hz, clk[1]=19200Hz, clk[2]=9600Hz clock).
module unbuffered_uart_rx(
    input  wire[2:0] clk,
    output reg [7:0] rx_byte,
    output reg       rx_trig,
    input  wire      rx_ack,
    input  wire      rxd,
    output wire      rx_busy
);
    // Counts number of received bits.
    reg[3:0]  state;
    // Buffer for receiving data.
    reg[8:0]  rx_buf;
    // Phase of the clock in which to sample bits.
    reg[1:0]  rx_phase;
    
    // RX is busy if state is nonzero.
    assign    rx_busy   = state != 0;
    
    initial begin
        state   = 0;
        rx_byte = 0;
        rx_buf  = 0;
        rx_trig = 0;
    end
    
    always @(posedge clk[0]) begin
        if (state == 0 && rxd == 0) begin
            // Initialise receiver state.
            rx_buf   <= 0;
            state    <= 1;
            rx_phase <= clk[2:1] ^ 2;
            rx_trig  <= rx_trig && !rx_ack;
        end else if (state != 0 && clk[2:1] == rx_phase) begin
            if (state == 10 && rxd == 1) begin
                // Stop bit is received; accept message.
                state    <= 0;
                rx_byte  <= rx_buf[8:1];
                rx_trig  <= 1;
            end else if (state == 10 && rxd == 0) begin
                // Stop bit is not received; discard message.
                state    <= 15;
                rx_trig  <= rx_trig && !rx_ack;
            end else if (state == 15) begin
                // Testing for stop bit after discarded message.
                state    <= rxd == 1 ? 0 : 15;
                rx_trig  <= rx_trig && !rx_ack;
            end else begin
                // Receive a bit.
                state    <= state + 1;
                rx_buf   <= (rx_buf >> 1) | (rxd << 8);
                rx_trig  <= rx_trig && !rx_ack;
            end
        end else begin
            rx_trig  <= rx_trig && !rx_ack;
        end
    end
endmodule

// Basic UART module.
// Takes a clock that is 4x baudrate (e.g. 9600 baud means a 38400Hz clock).
module axo_peri_uart#(
    // TX buffer depth, must be a power of 2 >= 4.
    parameter tx_depth      = 16,
    // RX buffer depth, must be a power of 2 >= 4.
    parameter rx_depth      = 16,
    // Stall writes on TX buffer full.
    parameter tx_full_stall = 1
)(
    // Peripheral bus clock.
    input  logic        clk,
    // Global reset.
    input  logic        rst,
    // Peripheral bus interface.
    axo_peri_bus.MEM    bus,
    
    // UART clock: exactly 2x baud rate.
    input  logic        uart_clk,
    // Transmitted data pin.
    output logic        txd,
    // Received data pin.
    input  logic        rxd,
    
    // UART receive buffer is no longer empty.
    output logic        rx_full,
    // UART transmit buffer has emptied.
    output logic        tx_empty
);
    genvar i;
    localparam tx_exp = $clog2(tx_depth) - 1;
    localparam rx_exp = $clog2(rx_depth) - 1;
    
    // Clock divider.
    reg  [1:0] clk_div_reg;
    wire [2:0] clk_div;
    assign clk_div[0]   = uart_clk;
    assign clk_div[2:1] = clk_div_reg;
    always @(posedge uart_clk) begin
        clk_div_reg <= clk_div_reg + 1;
    end
    
    
    
    // UART transmiter wires.
    logic           tx_trig;
    reg  [tx_exp:0] tx_prod;
    reg  [tx_exp:0] tx_cons;
    wire [tx_exp:0] tx_prod_next = tx_prod + 1;
    wire [tx_exp:0] tx_cons_next = tx_cons + 1;
    reg  [7:0]      tx_buf[tx_depth];
    wire            tx_busy;
    
    // UART transmitter PHY.
    unbuffered_uart_tx utx(clk_div[2], tx_buf[tx_cons], tx_trig, txd, tx_busy);
    
    // UART transmitter logic.
    always @(posedge clk) begin
        if (rst) begin
            // Reset.
            tx_prod <= 0;
            
        end else if (tx_prod_next != tx_cons && bus.we && bus.addr[3:2] == 0) begin
            // UART write triggered.
            tx_buf[tx_prod] <= bus.wdata[7:0];
            tx_prod         <= tx_prod_next;
        end
    end
    
    assign tx_empty = tx_prod == tx_cons;
    always @(posedge clk_div[2]) begin
        if (rst) begin
            // Reset.
            tx_cons <= 0;
            
        end else if (tx_trig) begin
            // TX sent a byte.
            tx_cons <= tx_cons_next;
            tx_trig <= 0;
            
        end else begin
            // Send a TX byte next.
            tx_trig <= tx_prod != tx_cons && !tx_busy;
        end
    end
    
    
    
    // UART receiver wires.
    wire            rx_trig;
    wire [7:0]      rx_byte;
    reg  [rx_exp:0] rx_prod;
    reg  [rx_exp:0] rx_cons;
    wire [rx_exp:0] rx_prod_next = rx_prod + 1;
    wire [rx_exp:0] rx_cons_next = rx_cons + 1;
    reg  [7:0]      rx_buf[rx_depth];
    wire            rx_busy;
    
    // UART receiver PHY.
    unbuffered_uart_rx urx(clk_div, rx_byte, rx_trig, 1, rxd, rx_busy);
    
    // UART receiver logic.
    always @(posedge clk_div[0]) begin
        if (rst) begin
            // Reset.
            rx_prod <= 0;
            
        end else if (rx_trig && rx_prod_next != rx_cons) begin
            // RX received a byte.
            rx_buf[rx_prod] <= rx_byte;
            rx_prod         <= rx_prod_next;
        end
    end
    
    assign rx_full = rx_prod != rx_cons;
    always @(posedge clk) begin
        if (rst) begin
            // Reset.
            rx_cons <= 0;
            
        end else if (rx_cons != rx_prod && bus.re && bus.addr[2] == 0) begin
            // UART receive requested.
            rx_cons <= rx_cons_next;
        end
    end
    
    
    
    // Response logic.
    logic[31:0] status;
    assign status[0]        = tx_busy;
    assign status[1]        = tx_prod != tx_cons;
    assign status[2]        = tx_prod_next == tx_cons;
    assign status[15:3]     = 0;
    assign status[16]       = rx_busy;
    assign status[17]       = rx_prod != rx_cons;
    assign status[18]       = rx_prod_next == rx_cons;
    assign status[31:19]    = 0;
    always @(*) begin
        if (tx_prod_next == tx_cons && bus.we && bus.addr[2] == 0) begin
            // UART write stall.
            bus.ready = !tx_full_stall;
            bus.rdata = rx_buf[rx_cons];
            
        end else if (bus.re && bus.addr[2] == 0) begin
            // UART read.
            bus.ready = 1;
            bus.rdata = rx_buf[rx_cons];
            
        end else if (bus.addr[2] == 1) begin
            // UART status.
            bus.ready = 1;
            bus.rdata = status;
            
        end else begin
            // Nothing to wait for.
            bus.ready = 1;
            bus.rdata = 'bx;
        end
    end
    
endmodule
