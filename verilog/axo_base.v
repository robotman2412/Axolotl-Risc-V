
// Risc-V opcodes.
parameter RV_OP_LOAD		= 'b00000;
parameter RV_OP_LOAD_FP		= 'b00001;
parameter RV_OP_custom_0	= 'b00010;
parameter RV_OP_MISC_MEM	= 'b00011;
parameter RV_OP_OP_IMM		= 'b00100;
parameter RV_OP_AUIPC		= 'b00101;
parameter RV_OP_OP_IMM_32	= 'b00110;
parameter RV_OP_STORE		= 'b01000;
parameter RV_OP_STORE_FP	= 'b01001;
parameter RV_OP_custom_1	= 'b01010;
parameter RV_OP_AMO			= 'b01011;
parameter RV_OP_OP			= 'b01100;
parameter RV_OP_LUI			= 'b01101;
parameter RV_OP_OP_32		= 'b01110;
parameter RV_OP_MADD		= 'b10000;
parameter RV_OP_MSUB		= 'b10001;
parameter RV_OP_NMSUB		= 'b10010;
parameter RV_OP_NMADD		= 'b10011;
parameter RV_OP_OP_FP		= 'b10100;
parameter RV_OP_BRANCH		= 'b11000;
parameter RV_OP_JALR		= 'b11001;
parameter RV_OP_JAL			= 'b11011;
parameter RV_OP_SYSTEM		= 'b11100;

// Risc-V ALU funct3 values.
parameter RV_ALU_ADD		= 'b000;
parameter RV_ALU_SLL		= 'b001;
parameter RV_ALU_SLT		= 'b010;
parameter RV_ALU_SLTU		= 'b011;
parameter RV_ALU_XOR		= 'b100;
parameter RV_ALU_SRL		= 'b101;
parameter RV_ALU_OR			= 'b110;
parameter RV_ALU_AND		= 'b111;



// XLEN-bit dual-read, single-write register file.
module axo_regfile#(
	// XLEN; amount of bits for registers.
	parameter XLEN = 32
)(
	// Write synchronisation.
	input  wire           clk,
	// When raised to 1, reset all registers to 0.
	input  wire           rst,
	
	// Write index.
	// Index 0 is ignored.
	input  wire[4:0]      rd,
	// Read index 1.
	// Index 0 always yields output of zero.
	input  wire[4:0]      rs1,
	// Read index 2.
	// Index 0 always yields output of zero.
	input  wire[4:0]      rs2,
	
	// Write enable.
	// Must be high when `clk` rises to enable writes.
	input  wire           we,
	// Read enable 1.
	// If 0, `dout1` enters a high-z state.
	input  wire           re1,
	// Read enable 2.
	// If 0, `dout1` enters a high-2 state.
	input  wire           re2,
	
	// Write data.
	input  wire[XLEN-1:0] din,
	// Read data 1.
	output wire[XLEN-1:0] dout1,
	// Read data 2.
	output wire[XLEN-1:0] dout2
);
	
	initial begin
		// Initially set regfile to all 0.
		for (i = 0; i < 32; i=i+1) begin
			data[i] = 0;
		end
	end
	
	// This is where the actual data is kept.
	reg[XLEN-1:0] data[31:0];
	
	// Read port 1.
	assign dout1 = re1 ? data[rs1] : 'bz;
	// Read port 2.
	assign dout2 = re2 ? data[rs2] : 'bz;
	
	// Writing logic.
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			// Reset regfile to all 0.
			for (i = 0; i < 32; i=i+1) begin
				data[i] = 0;
			end
		end else if (clk) begin
			// Except for `x0`, write handler.
			if (rd != 0 && we) begin
				data[rd] = din;
			end
		end
	end
endmodule



// XLEN-bit integer ALU.
module axo_alu#(
	// XLEN; amount of bits for inputs and outputs.
	parameter XLEN = 32
)(
	// Funct3 bits from instruction.
	// Used to determine operation type.
	input  wire[2:0]      funct3,
	// Bit 30 of instruction.
	// Turns ADD into sub, SRL into SRA.
	input  wire           inst30,
	
	// Perform OP-IMM (default is OP).
	input  wire           op_imm,
	// Perform subtraction despite `funct3` and `inst30`.
	input  wire           op_branch,
	
	// First (lefthand) input.
	input  wire[XLEN-1:0] in1,
	// Second (righthand) input.
	input  wire[XLEN-1:0] in2,
	
	// Output.
	output wire[XLEN-1:0] out,
	// Carry flag.
	output wire           cflag,
	// Zero flag.
	output wire           zflag
);
	// Invert branch condition.
	wire inv_br    = funct3[0];
	// Use signed comparison.
	wire signed_br = funct3[1];
	// Less than (signed_br=0) / greater than or equal to (signed_br=1).
	wire diff_br   = funct3[2];
	
	// Modifiable copy of `funct3`.
	wire funct3_tmp = !op_branch ? funct3
					: signed_br ? RV_ALU_SLT
					: RV_ALU_SLTU;
	
	// XLEN+1-bit output (to get carry from ADD/SUB).
	reg out_tmp[XLEN:0];
	// Comparison result device.
	reg cmp_res;
	
	// Extract flags.
	assign cflag = out_tmp[XLEN];
	assign zflag = out_tmp[XLEN-1:0] == 0;
	
	// Create output bits.
	assign out = (funct3_tmp[2:1] == 'b01) ? cmp_res : out_tmp[XLEN-1:0];
	
	always @(*) begin
		// Perform computations.
		case(funct3_tmp)
			// Addition (inst30=0) / subtraction (inst30=1).
			RV_ALU_ADD:  out_tmp = inst30 ? in1 - in2 : in1 + in2;
			// Logical shift left.
			RV_ALU_SLL:  out_tmp = in1 << (in2 & 31);
			// Set less than (signed compare).
			RV_ALU_SLT:  out_tmp = (in1 ^ (1 << (XLEN-1))) - (in2 ^ (1 << (XLEN-1)));
			// Set less than (unsigned compare).
			RV_ALU_SLTU: out_tmp = in1 - in2;
			// Bitwise XOR.
			RV_ALU_XOR:  out_tmp = in1 ^ in2;
			// Logical (inst30=0) / arithmetic (inst30=1) shift right.
			RV_ALU_SRL:  out_tmp = in1 >> (in2 & 31);
			// Bitwise OR.
			RV_ALU_OR:   out_tmp = in1 | in2;
			// Bitwise AND.
			RV_ALU_AND:  out_tmp = in1 & in2;
		endcase
	end
	
	always @(*) begin
		// Evaluate conditionals.
		if (op_branch) begin
			// Branch conditionals.
			if (diff_br) begin
				cmp_res = inv_br ^ (!zflag & !cflag);
			end else begin
				cmp_res = inv_br ^ zflag;
			end
		end else begin
			// Set less than conditionals.
			cmp_res = !zflag & !cflag;
		end
	end
endmodule



// Immediate operand decoder.
module axo32_decd_imm32(
	// Input instruction to analyse.
	input  wire[31:0] inst,
	// Embedded immediate value, if any.
	output wire[31:0] imm,
	
	// Instruction is R-type.
	input wire is_r_type,
	// Instruction is I-type.
	input wire is_i_type,
	// Instruction is S-type.
	input wire is_s_type,
	// Instruction is B-type.
	input wire is_b_type,
	// Instruction is U-type.
	input wire is_u_type,
	// Instruction is J-type.
	input wire is_j_type
);
	// Bit 0.
	assign imm[0] =
				is_i_type ? inst[20] :
				is_s_type ? inst[7]  : 0;
	
	// Bits 1-4.
	assign imm[4:1] =
				is_i_type ? inst[24:21] :
				is_s_type ? inst[11:8] :
				is_b_type ? inst[11:8] :
				// is_u_type ? 0 :
				is_j_type ? inst[24:21] : 0;
	
	// Bits 5-10.
	assign imm[10:5] =
				is_u_type ? 0 : inst[30:25];
	
	// Bit 11.
	assign imm[11] =
				is_i_type ? inst[31] :
				is_s_type ? inst[31] :
				is_b_type ? inst[7] :
				// is_u_type ? 0 :
				is_j_type ? inst[20] : 0;
	
	// Bits 12-19.
	assign imm[19:12] =
				is_u_type ? inst[19:12] :
				is_j_type ? inst[19:12] : inst[31] * 'h2f;
	
	// Bits 20-30.
	assign imm[30:20] =
				is_u_type ? inst[30:20] : inst[31] * 'h3ff;
	
	// Bit 31.
	assign imm[10:5] = inst[31];
endmodule



// Base RV32 instruction decoder.
// All more advanced decoders have this as their base.
module axo32_decoder(
	// Input instruction to analyse.
	input  wire[31:0] inst,
	
	// Whether this opcode is recognised by base RV32I.
	output wire op_valid,
	
	// Operation will read from memory.
	output wire op_will_read,
	// Operation will write to memory.
	output wire op_will_write,
	// Operation will use ALU.
	output wire op_uses_alu,
	// Operation is execution flow control.
	output wire op_does_flowctl,
	
	// Operation equals `ECALL`.
	output wire op_is_ecall,
	// Operation equals `EBREAK`.
	output wire op_is_ebreak,
	
	// Operation must use 32 bits instead of XLEN (64 / 128).
	output wire op_32bit,
	
	// Embedded immediate value, if any.
	output wire[31:0] imm
);
	
	// Stores the values for is_*_type and op_will_*.
	reg[10:0] is_type_reg;
	assign op_valid        = is_type_reg[10];
	assign op_will_read    = is_type_reg[9];
	assign op_will_write   = is_type_reg[8];
	assign op_uses_alu     = is_type_reg[7];
	assign op_does_flowctl = is_type_reg[6];
	
	// Instruction is R-type.
	wire is_r_type = is_type_reg[5];
	// Instruction is I-type.
	wire is_i_type = is_type_reg[4];
	// Instruction is S-type.
	wire is_s_type = is_type_reg[3];
	// Instruction is B-type.
	wire is_b_type = is_type_reg[2];
	// Instruction is U-type.
	wire is_u_type = is_type_reg[1];
	// Instruction is J-type.
	wire is_j_type = is_type_reg[0];
	
	// Determine instruction encoding type.
	always @(*) begin
		case(inst[6:2])                  // v rwaf RIS BUJ
			RV_OP_LOAD:			is_type_reg = 'b1_1000_010_000;
			RV_OP_MISC_MEM:		is_type_reg = 'b1_0000_010_000;
			RV_OP_OP_IMM:		is_type_reg = 'b1_0010_010_000;
			RV_OP_OP_IMM_32:	is_type_reg = 'b1_0010_010_000;
			RV_OP_AUIPC:		is_type_reg = 'b1_0000_000_010;
			RV_OP_STORE:		is_type_reg = 'b1_0100_001_000;
			RV_OP_OP:			is_type_reg = 'b1_0010_100_000;
			RV_OP_OP_32:		is_type_reg = 'b1_0010_100_000;
			RV_OP_LUI:			is_type_reg = 'b1_1000_000_010;
			RV_OP_BRANCH:		is_type_reg = 'b1_0011_000_100;
			RV_OP_JALR:			is_type_reg = 'b1_0001_010_000;
			RV_OP_JAL:			is_type_reg = 'b1_0001_000_001;
			RV_OP_SYSTEM:		is_type_reg = 'b1_0000_000_000;
			default:			is_type_reg = 'b0_0000_000_000;
		endcase
	end
	assign op_32bit = inst[6:2] == RV_OP_OP_IMM_32 || inst[6:2] == RV_OP_OP_32;
	
	// Detect ECALL and EBREAK.
	assign op_is_ebreak = inst[6:2] == RV_OP_SYSTEM && inst[20] == 1;
	assign op_is_ecall  = inst[6:2] == RV_OP_SYSTEM && inst[20] == 0;
	
	// Compute imm value.
	axo32_decd_imm32 decd_imm32(
		inst,
		imm,
		is_r_type,
		is_i_type,
		is_s_type,
		is_b_type,
		is_u_type,
		is_j_type
	);
	
endmodule
