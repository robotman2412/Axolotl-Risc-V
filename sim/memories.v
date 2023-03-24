
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
	// Data.
	inout  wire[31:0] data
);
	// Internal storage.
	reg[7:0] storage[dept-1:0];
	
	// Read logic.
	assign data[7:0]  = !re ? 'bz : storage[addr];
	assign data[15:8] = !re || asize < 1 ? 'bz : storage[addr+1];
	assign data[23:16] = !re || asize < 1 ? 'bz : storage[addr+2];
	assign data[31:24] = !re || asize < 1 ? 'bz : storage[addr+3];
	
	always @(posedge clk) begin
		// Write logic.
		if (we)
	end
endmodule

// 32-bit RAM that can be accessed as 8- and 16-bit RAM.
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
	// Data.
	inout  wire[31:0] data,
	
	// Misalignment error.
	output wire alignerr
);
	// Internal storage.
	reg[31:0] storage[depth-1:0];
	
	// Read logic.
	assign data = !re ? 'bz
				: asize == 0 ? (storage[addr>>2] >> (8*(addr&3))) & 'h000000ff
				: asize == 1 ? (storage[addr>>2] >> (8*(addr&2))) & 'h0000ffff
				: asize == 2 ? storage[addr>>2]
				: 'bz;
	
	// Alignment checking logic.
	assign alignerr = !(we | re) ? 0
					: asize == 0 ? 0
					: asize == 1 ? addr[0]
					: asize == 2 ? addr[1] | addr[0]
					: 1;
	
	always @(posedge clk) begin
		// Write logic.
		if (we && asize == 0) begin
			// 8-bit write.
			if (addr[1:0] == 0) begin
				storage[addr>>2][31:24] = data[7:0];
			end else if (addr[1:0] == 1) begin
				storage[addr>>2][23:16] = data[7:0];
			end else if (addr[1:0] == 2) begin
				storage[addr>>2][15:8] = data[7:0];
			end else if (addr[1:0] == 3) begin
				storage[addr>>2][7:0] = data[7:0];
			end
		end else if (we && asize == 1) begin
			// 16-bit write.
			if (addr[1]) begin
				storage[addr>>2][31:16] = data[15:0];
			end else begin
				storage[addr>>2][15:0] = data[15:0];
			end
		end else if (we && asize == 2) begin
			// 32-bit write.
			storage[addr>>2] <= data;
		end
	end
	
endmodule



// Simple implementation of RAM.
module simple_ram #(
	// Width of data.
	parameter data_width = 8,
	// Width of address bus.
	parameter addr_width = 4,
	// Amount of `data_width` words.
	parameter depth = 16
)(
	// Write synchronisation.
	input wire clk,
	
	// Read enable.
	input wire re,
	// Write enable.
	input wire we,
	
	// Address.
	input wire[addr_width-1:0] addr,
	// Data.
	inout wire[data_width-1:0] data
);
	// Internal storage.
	reg[data_width-1:0] storage[depth-1:0];
	
	// Read logic.
	assign data = re ? storage[addr] : 'bz;
	
	always @(posedge clk) begin
		// Write logic.
		if (we) begin
			storage[addr] = data;
		end
	end
endmodule
