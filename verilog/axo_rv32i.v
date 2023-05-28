
/*
	This work ("Axolotl³²") is licensed under a Creative Commons
	Attribution-NonCommercial-ShareAlike 4.0 International License:
	
	https://creativecommons.org/licenses/by-nc-sa/4.0/
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
	output reg        mem_re,
	// Write to memory.
	output reg        mem_we,
	// Memory access size in 2^n bytes.
	output reg [1:0]  mem_asize,
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
	// Current instruction.
	reg[31:0]  inst;
	
	// Previous value of PC; typically pc-4.
	reg[31:0]  prev_pc;
	// Current instruction address.
	reg[31:0]  pc;
	// Branch target address.
	reg[31:0]  branch_target;
	// Whether to take a branch.
	reg        branch_taken;
	
	// Determines whether to stall instruction execution.
	wire exec_stall;
	
	// Data bus.
	reg [31:0] data_bus;
	// Operand 1 bus.
	wire[31:0] op1_bus;
	// Operand 2 bus.
	wire[31:0] op2_bus;
	
	// Wires from base decoder.
	wire op_valid, op_is_compressed;
	wire[4:0] opcode;
	wire op_will_read, op_will_write;
	wire op_uses_alu, op_does_flowctl;
	wire op_is_ecall, op_is_ebreak;
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
		op_does_flowctl, op_is_imm,
		op1_bus, op2_bus,
		alu_q
	);
	
	
	
	// Base instruction decoder.
	assign crash      = xstate == XS_CRASH;
	assign exec_stall = (mem_re | mem_we) && !mem_ready;
	axo32_decoder decd(
		inst, op_valid,
		op_is_compressed, opcode,
		
		op_will_read, op_will_write,
		op_uses_alu, op_does_flowctl,
		op_is_ecall, op_is_ebreak,
		
		op_is_lui, op_is_auipc,
		op_is_imm, imm,
		
		rd_we, rs1_re, rs2_re,
		rd,    rs1,    rs2
	);
	
	
	
	
	// Bus logic.
	assign op2_bus   = rs2_re ? 'bz : imm;
	
	always @(*) begin
		if (op_uses_alu) begin
			data_bus <= alu_q;
		end else if (op_will_read) begin
			data_bus <= mem_data;
		end else if (opcode == `RV_OP_AUIPC) begin
			data_bus <= imm + prev_pc;
		end else if (rd_we) begin
			data_bus <= imm;
		end else begin
			data_bus <= 0;
		end
	end
	
	// Memory access logic.
	assign prog_re   = xstate == XS_LOAD;
	assign prog_addr = pc;
	assign mem_data  = mem_we ? op2_bus : 'bz;
	assign mem_addr  = imm + op1_bus;
	always @(*) begin
		if (op_will_write) begin
			mem_re    <= 0;
			mem_we    <= xstate == XS_EXEC;
			mem_asize <= inst[14:12];
		end else if (op_will_read) begin
			mem_re    <= xstate == XS_EXEC;
			mem_we    <= 0;
			mem_asize <= inst[14:12];
		end else begin
			mem_re    <= 0;
			mem_we    <= 0;
			mem_asize <= 0;
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
	
	
	
	// Branching logic.
	always @(*) begin
		if (opcode == `RV_OP_JAL) begin
			branch_taken  <= 1;
			branch_target <= prev_pc + imm;
		end else if (opcode == `RV_OP_JALR) begin
			branch_taken <= 1;
			branch_target <= imm + op1_bus;
		end else if (opcode == `RV_OP_BRANCH) begin
			branch_taken  <= alu_q[0];
			branch_target <= prev_pc + imm;
		end else begin
			branch_taken  <= 0;
			branch_target <= 'bx;
		end
	end
	always @(posedge clk) begin
		if (!rst && xstate == XS_EXEC && branch_taken) begin
			pc <= branch_target;
		end
	end
	
	
	
	// Synchronous logic.
	always @(posedge clk, posedge rst) begin
		if (!rst) begin
			$display("%0h  %02h %02h %02h %08h %08h %08h %08h %08h %08h %0h", xstate, rs1, rs2, rd, pc, imm, op1_bus, op2_bus, data_bus, alu_q, crash);
		end
		if (rst) begin
			// Reset execution state.
			prev_pc <= 0;
			pc      <= 0;
			xstate  <= XS_LOAD;
			inst    <= 0;
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
				inst    <= prog_data;
				$display("Loaded 0x%08h", prog_data);
				prev_pc <= pc;
				pc      <= pc + 4;
				xstate  <= XS_EXEC;
			end
			
		end else begin
			// If we get here, something went terribly wrong.
			xstate <= XS_CRASH;
		end
		$display();
	end
	
endmodule
