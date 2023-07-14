`timescale 1ns / 1ps

/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

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
		end else begin
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

// Unbuffered UART.
// Takes a clock that is 4x baudrate (e.g. 9600 baud means a 38400Hz clock).
module unbuffered_uart(
	input  wire      clk,
	
	output reg [7:0] rx_byte,
	input  wire[7:0] tx_byte,
	
	input  wire      tx_trig,
	output reg       rx_trig,
	input  wire      rx_ack,
	
	output wire      txd,
	input  wire      rxd,
	
	output reg       tx_busy,
	output wire      rx_busy
);
	// Synthesize clocks.
	reg[1:0] clk_div;
	always @(negedge clk) begin
		clk_div <= clk_div + 1;
	end
	wire[2:0] clk_out = (clk_div<<1) | clk;
	
	// Simple forwarding.
	unbuffered_uart_tx uart_tx(clk_out[2], tx_byte, tx_trig, txd, tx_busy);
	unbuffered_uart_rx uart_rx(clk_out, rx_byte, rx_trig, rx_ack, rxd, rx_busy);
endmodule
