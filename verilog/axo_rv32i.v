
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_base.v"

// Axolotl³² RV32I processor.
module axo_rv32i(
	// Clock source.
	input  wire clk,
	// Reset signal.
	input  wire rst,
	// Irrecoverable fault, reset required.
	output wire crash,
	
	
	// Read from memory
	output wire       mem_re,
	// Write to memory.
	output wire       mem_we,
	// Memory access size in 2^n bytes.
	output wire[1:0]  mem_asize,
	// CPU will stall on memory OPs while 0.
	input  wire       mem_ready,
	
	// Memory address bus.
	output wire[31:0] mem_addr,
	// Memory data bus.
	inout  wire[31:0] mem_data,
	
	
	// Read from program.
	output wire       prog_re,
	// CPU will stall loading instructions while 0.
	input  wire       prog_ready,
	
	// Program address bus.
	output wire[31:0] prog_addr,
	// Program data bus.
	input  wire[31:0] prog_data
);
	// Data bus.
	wire[31:0] data_bus;
	// Operand 1 bus.
	wire[31:0] op1_bus;
	// Operand 2 bus.
	wire[31:0] op2_bus;
	
	// RV32I register file.
	axo_regfile#(XLEN=32) regfile(
		clk, rst,
		
		rd, rs1, rs2,
		
		0, rs1_re, rs2_re,
		
		data_bus,
		op1_bus,
		op2_bus
	);
	
	// RV32I ALU.
	axo_alu#(XLEN=32) alu(
		0, 0,
		0, 0,
		op1_bus, op2_bus,
		alu_q
	);
	
	
	// Loading instruction.
	localparam XS_LOAD  = 0;
	// Performing simple op.
	localparam XS_OP    = 1;
	// Performing memory op.
	localparam XS_MEM   = 2;
	// Performing flow control op.
	localparam XS_FLOW  = 3;
	// Crashed.
	localparam XS_CRASH = 15;
	
	// Current execution/loading state.
	reg[3:0]   xstate;
	// Crash is a possible `xstate` value.
	assign     crash = xstate == XS_CRASH;
	// Determine whether next `xstate` should be `XS_LOAD`.
	wire       xloadnext = xstate == XS_OP
						|| xstate == XS_MEM
						|| xstate == XS_FLOW;
	
	
	// Current instruction address.
	reg        pc;
	// Current instruction.
	reg [31:0] inst;
	
	
	// Base instruction decoder.
	wire op_valid;
	wire op_is_imm, rd_we, rs1_re, rs2_re;
	wire[4:0] rd, rs1, rs2;
	axo32_decoder decd(
		inst, op_valid,
		
		'bz, 'bz, 'bz, 'bz,
		'bz, 'bz,
		'bz,
		
		op_is_imm,
		imm,
		
		rd_we, rs1_re, rs2_re,
		rd,    rs1,    rs2
	);
	
	
	// Memory access logic.
	assign prog_re   = !isexec;
	assign prog_addr = pc;
	assign mem_data  = mem_we ? data_bus : 'bz;
	
	initial begin
		// Reset execution state.
		pc     <= 0;
		xstate <= XS_LOAD;
		inst   <= 0;
	end
	
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			// Reset execution state.
			pc     <= 0;
			xstate <= XS_LOAD;
			inst   <= 0;
			
		end else if (xloadnext) begin
			// Switch to instruction loading.
			isexec <= !(mem_ready & (mem_re | mem_we));
			
		end else if (xstate == XS_LOAD) begin
			// Switch to instruction execution.
			inst   <= prog_data;
			pc     <= pc + 4;
			
		end else begin
			// If we get here, something went terribly wrong.
			xstate <= XS_CRASH;
		end
	end
	
endmodule
