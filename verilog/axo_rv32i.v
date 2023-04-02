
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
	// Loading instruction.
	localparam XS_LOAD  = 0;
	// Running an instruction.
	localparam XS_EXEC  = 1;
	// Jumping to ISR.
	localparam XS_ISR   = 2;
	// Crashed.
	localparam XS_CRASH = 15;
	
	// Current execution/loading state.
	reg[3:0]   xstate;
	// Current instruction address.
	reg[31:0]  pc;
	// Current instruction.
	reg[31:0]  inst;
	
	// Determines whether to stall instruction execution.
	wire exec_stall;
	
	// Data bus.
	reg [31:0] data_bus;
	// Operand 1 bus.
	wire[31:0] op1_bus;
	// Operand 2 bus.
	wire[31:0] op2_bus;
	
	// Wires from base decoder.
	wire op_valid;
	wire op_will_read, op_will_write;
	wire op_uses_alu, op_does_flowctl;
	wire op_is_ecall, op_is_ebreak;
	wire op_32bit;
	wire op_is_lui, op_is_auipc, op_is_imm;
	wire[31:0] imm;
	wire rd_we, rs1_re, rs2_re;
	wire[4:0] rd, rs1, rs2;
	
	// Wires from ALU.
	wire[31:0] alu_q;
	
	
	
	// RV32I register file.
	axo_regfile#(.XLEN(32)) regfile(
		clk, rst,
		
		rd, rs1, rs2,
		
		xstate == XS_EXEC && rd_we && !exec_stall, rs1_re, rs2_re,
		
		data_bus,
		op1_bus,
		op2_bus
	);
	
	
	
	// RV32I ALU.
	axo_alu#(.XLEN(32)) alu(
		inst[14:12], inst[30],
		op_does_flowctl,
		op1_bus, op2_bus,
		alu_q
	);
	
	
	
	// Base instruction decoder.
	assign crash      = xstate == XS_CRASH;
	assign exec_stall = (mem_re | mem_we) && !mem_ready;
	axo32_decoder decd(
		inst, op_valid,
		
		op_will_read, op_will_write,
		op_uses_alu, op_does_flowctl,
		op_is_ecall, op_is_ebreak,
		op_32bit,
		
		op_is_lui, op_is_auipc,
		op_is_imm, imm,
		
		rd_we, rs1_re, rs2_re,
		rd,    rs1,    rs2
	);
	
	
	
	
	// Bus logic.
	assign op2_bus   = rs2_re ? 'bz : imm;
	
	// assign data_bus  = op_uses_alu ? alu_q : 'bz;
	
	assign prog_re   = xstate == XS_LOAD;
	assign prog_addr = pc;
	assign mem_re    = 0;
	assign mem_we    = 0;
	assign mem_data  = mem_we ? data_bus : 'bz;
	
	always @(*) begin
		if (op_uses_alu) begin
			data_bus <= alu_q;
		end else if (op_will_read) begin
			data_bus <= mem_data;
		end else if (rd_we) begin
			data_bus <= imm;
		end else begin
			data_bus <= 0;
		end
	end
	
	
	
	initial begin
		// Reset execution state.
		pc     <= 0;
		xstate <= XS_LOAD;
		inst   <= 0;
		$display("Initial reset");
		$display("XS s1 s2 d  PC       imm      P0       P1       D        Q        !");
	end
	
	
	
	// Synchronous logic.
	always @(posedge clk, posedge rst) begin
		if (!rst) begin
			$display("%0h  %02h %02h %02h %08h %08h %08h %08h %08h %08h %0h", xstate, rs1, rs2, rd, pc, imm, op1_bus, op2_bus, data_bus, alu_q, crash);
		end
		if (rst) begin
			// Reset execution state.
			pc     <= 0;
			xstate <= XS_LOAD;
			inst   <= 0;
			$display("Signalled reset");
			
		end else if (xstate == XS_EXEC) begin
			if (!op_valid) begin
				// Illegal instruction fault.
				xstate <= XS_CRASH;
				$display("Illegal instruction");
				
			end else if (!exec_stall) begin
				// Switch to instruction loading.
				xstate <= XS_LOAD;
				$display("Exec complete");
				
			end else begin
				$display("Exec stall");
			end
			
		end else if (xstate == XS_LOAD) begin
			if (pc & 3) begin
				// Instruction misalignment fault.
				xstate <= XS_CRASH;
				$display("Instruction misalign");
				
			end else if (prog_ready) begin
				// Switch to instruction execution.
				inst   <= prog_data;
				$display("Loaded 0x%08h", prog_data);
				pc     <= pc + 4;
				xstate <= XS_EXEC;
			end
			
		end else begin
			// If we get here, something went terribly wrong.
			xstate <= XS_CRASH;
		end
		$display();
	end
	
endmodule
