
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_defines.sv"

// XLEN-bit dual-read, single-write register file.
module axo_regfile#(
    // XLEN; amount of bits for registers.
    parameter XLEN = 32
)(
    // Write synchronisation.
    input  logic           clk,
    // When raised to 1, reset all registers to 0.
    input  logic           rst,
    
    // Write index.
    // Index 0 is ignored.
    input  logic[4:0]      rd,
    // Read index 1.
    // Index 0 always yields output of zero.
    input  logic[4:0]      rs1,
    // Read index 2.
    // Index 0 always yields output of zero.
    input  logic[4:0]      rs2,
    
    // Write enable.
    // Must be high when `clk` rises to enable writes.
    input  logic           we,
    
    // Write data.
    input  logic[XLEN-1:0] din,
    // Read data 1.
    output logic[XLEN-1:0] dout1,
    // Read data 2.
    output logic[XLEN-1:0] dout2
);
    
    // Used for resetting.
    integer i;
    
    initial begin
        // Initially set regfile to all 0.
        for (i = 1; i < 32; i=i+1) begin
            data[i] = 0;
        end
    end
    
    // This is where the actual data is kept.
    reg[XLEN-1:0] data[31:1];
    
    // Read port 1.
    assign dout1 = rs1 ? data[rs1] : 0;
    // Read port 2.
    assign dout2 = rs2 ? data[rs2] : 0;
    
    // Writing logic.
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            // Reset regfile to all 0.
            for (i = 1; i < 32; i=i+1) begin
                data[i] = 0;
            end
        end else if (clk) begin
            // Except for `x0`, write handler.
            if (rd != 0 && we) begin
                data[rd] = din;
                $display("x%0d = %08h", rd, din);
            end
        end
    end
endmodule



// Determines the address for jump or conditional branch instructions.
module axo_branch_target(
    // Control transfer instruction.
    input  logic[31:0] insn,
    // Current instruction PC value.
    input  logic[31:1] pc_val,
    // Either mepc or sepc for mret or sret respectively.
    input  logic[31:1] epc_val,
    // Value of RS1'th register.
    input  logic[31:0] rs1_val,
    // Calculated branch address.
    // Only valid for control transfer instructions.
    output logic[31:1] addr
);
    wire [31:0] branch_base = insn[3:2] == 2'b01 ? rs1_val : pc_val;
    logic[31:0] branch_off;
    wire [31:1] branch_addr = branch_base + branch_off;
    logic       is_mret;
    assign      addr        = is_mret ? epc_val : branch_addr;
    
    always @(*) begin
        if (axo_insn_opcode(insn) == `RV_OP_JAL) begin
            // Jump and link relative.
            branch_off[0]       = 0;
            branch_off[10:1]    = insn[30:21];
            branch_off[11]      = insn[20];
            branch_off[19:12]   = insn[19:12];
            branch_off[20]      = insn[31];
            is_mret             = 0;
            
        end else if (axo_insn_opcode(insn) == `RV_OP_JALR) begin
            // Jump and link register.
            branch_off[11:0]    = insn[31:20];
            branch_off[20:12]   = insn[31] ? 9'h1ff : 9'h000;
            is_mret             = 0;
            
        end else if (axo_insn_opcode(insn) == `RV_OP_BRANCH) begin
            // Conditional branches.
            branch_off[0]       = 0;
            branch_off[4:1]     = insn[11:8];
            branch_off[10:5]    = insn[30:25];
            branch_off[11]      = insn[7];
            branch_off[12]      = insn[30];
            branch_off[20:13]   = insn[31] ? 8'hff : 8'h00;
            is_mret             = 0;
            
        end else begin
            // Only other control transfer instructions is:
            // MRET / SRET.
            branch_off[20:0]    = 'bx;
            is_mret             = 1;
        end
        branch_off[31:21] = branch_off[20] ? 11'h7ff : 11'h000;
    end
endmodule



// Determines the presence of registers in instructions.
module axo_reg_decoder#(
    // Check for atomic instructions.
    parameter a = 0,
    // Check for float instructions.
    parameter f = 0,
    // Check for RV64 instructions.
    parameter rv64 = 0
)(
    input  logic[31:0]  insn,
    output logic        has_rs1,
    output logic        has_rs2,
    output logic        has_rs3,
    output logic        has_rd
);
    `include "axo_functions.sv"
    
    always @(*) begin
        has_rs1 = 'b0; has_rs2 = 'b0; has_rs3 = 'b0; has_rd = 'b0;
        case (axo_insn_opcode(insn))
            `RV_OP_LOAD:        begin has_rs1 = 1; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_LOAD_FP:     if (f) begin has_rs1 = 1; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_MISC_MEM:    begin has_rs1 = 0; has_rs2 = 0; has_rs3 = 0; has_rd = 0; end
            `RV_OP_OP_IMM:      begin has_rs1 = 1; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_AUIPC:       begin has_rs1 = 0; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_OP_IMM_32:   if (rv64) begin has_rs1 = 1; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_STORE:       begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 0; end
            `RV_OP_STORE_FP:    if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 0; end
            `RV_OP_AMO:         if (a) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 1; end
            `RV_OP_OP:          begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 1; end
            `RV_OP_LUI:         begin has_rs1 = 0; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_OP_32:       if (rv64) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 1; end
            `RV_OP_MADD:        if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 1; has_rd = 1; end
            `RV_OP_MSUB:        if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 1; has_rd = 1; end
            `RV_OP_NMSUB:       if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 1; has_rd = 1; end
            `RV_OP_NMADD:       if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 1; has_rd = 1; end
            `RV_OP_OP_FP:       if (f) begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 1; end
            `RV_OP_BRANCH:      begin has_rs1 = 1; has_rs2 = 1; has_rs3 = 0; has_rd = 0; end
            `RV_OP_JALR:        begin has_rs1 = 1; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_JAL:         begin has_rs1 = 0; has_rs2 = 0; has_rs3 = 0; has_rd = 1; end
            `RV_OP_SYSTEM:
                begin
                    if (insn[14:12] != 0) begin
                        has_rs1 = !insn[14]; has_rs2 = 0; has_rd = 1;
                    end else begin
                        has_rs1 = 0; has_rs2 = 0; has_rd = 0;
                    end
                end
        endcase
    end
endmodule



// Verifies the validity of an uncompressed instruction.
module axo_insn_validator#(
    // Allow multiply/divide instructions.
    parameter has_m = 0,
    // Allow atomic instructions.
    parameter has_a = 0,
    // Allow float instructions.
    parameter has_f = 0,
    // Allow double instructions.
    parameter has_d = 0,
    // Allow long double instructions.
    parameter has_q = 0,
    // Allow CSR instructions.
    parameter has_zicsr = 0,
    // Allow fence.i instructions.
    parameter has_zifencei = 0,
    // Allow S-mode instructions.
    parameter has_s_mode = 0
)(
    // Instruction to verify.
    input  logic[31:0] insn,
    // Current privilege level.
    input  logic[1:0]  privilege,
    // Allow RV64 instructions.
    input  logic       rv64,
    // Current value of misa.
    input  logic[31:0] misa,
    
    // Instruction is recognised.
    output logic       valid,
    // Instruction is allowed in current privilege level.
    // May still be 1 if valid is 0.
    output logic       legal
);
    `include "axo_functions.sv"
    
    // Evaluate misa.
    wire allow_m        = (misa & `RV_MISA_M) && has_m;
    wire allow_a        = (misa & `RV_MISA_A) && has_a;
    wire allow_f        = (misa & `RV_MISA_F) && has_f;
    wire allow_d        = (misa & `RV_MISA_D) && has_d;
    wire allow_q        = (misa & `RV_MISA_Q) && has_q;
    wire allow_zicsr    = has_zicsr;
    wire allow_zifencei = has_zifencei;
    wire allow_s_mode   = (misa & `RV_MISA_S) && has_s_mode;
    
    
    
    // ALU operation verifier.
    logic valid_op_imm;
    always @(*) begin
        if (axo_insn_funct3(insn) == `RV_ALU_SLL) begin
            // Shift left.
            valid_op_imm = insn[31:26] == 0 && (rv64 && !insn[3] || !insn[25]);
            
        end else if (axo_insn_funct3(insn) == `RV_ALU_SRL) begin
            // Shift right.
            valid_op_imm = insn[31] == 0 && insn[29:26] == 0 && (rv64 && !insn[5] || !insn[25]);
            
        end else begin
            // Any other OP-IMM or OP-IMM-32.
            valid_op_imm = 1;
        end
    end
    
    logic valid_op;
    always @(*) begin
        if (insn[25]) begin
            // Multiply / divide.
            if (rv64 && insn[3]) begin
                valid_op = insn[31:26] == 0 && (insn[14] || insn[13:12] != 0);
            end else begin
                valid_op = insn[31:26] == 0;
            end
            
        end else if (axo_insn_funct3(insn) == `RV_ALU_SLL) begin
            // Shift left.
            valid_op = insn[31:26] == 0 && (rv64 && !insn[3] || !insn[25]);
            
        end else if (axo_insn_funct3(insn) == `RV_ALU_SRL) begin
            // Shift right.
            valid_op = insn[31] == 0 && insn[29:26] == 0 && (rv64 && !insn[3] || !insn[25]);
            
        end else if (axo_insn_funct3(insn) == `RV_ALU_ADD) begin
            // Add / subtract.
            valid_op = insn[31] == 0 && insn[29:26] == 0 && (rv64 && !insn[3] || !insn[25]);
            
        end else begin
            // Any other OP or OP-32.
            valid_op = insn[31:25] == 0;
        end
    end
    
    
    
    // SYSTEM opcode verifier.
    logic valid_system;
    logic legal_system;
    always @(*) begin
        if (axo_insn_funct3(insn) == 3'b000) begin
            // Privileged instructions.
            casex (insn[31:20])
                default:            begin valid_system = 0;          legal_system = 1; end
                12'b0000000_0000?:  begin valid_system = 1;          legal_system = 1; end
                12'b0001000_00010:  begin valid_system = has_s_mode; legal_system = privilege[0]; end
                12'b0011000_00010:  begin valid_system = 1;          legal_system = privilege[1]; end
                12'b0011000_00101:  begin valid_system = 1;          legal_system = 1; end
            endcase
        end else begin
            // CSR instructions.
            valid_system = axo_insn_funct3(insn) != 3'b100;
            legal_system = 1;
        end
    end
    
    
    
    // Output multiplexer.
    always @(*) begin
        legal = 1;
        if (insn[1:0] != 2'b11) begin
            valid = 0;
        end else case (axo_insn_opcode(insn))
            default:            begin valid = 0; end
            `RV_OP_LOAD:        begin valid = insn[14] ? insn[13:12] < 2 + rv64 : insn[13:12] < 3 + rv64; end
            `RV_OP_LOAD_FP:     begin valid = 0; $strobe("TODO: validity for LOAD_FP"); end
            `RV_OP_MISC_MEM:    begin valid = insn[14:13] == 0; end
            `RV_OP_OP_IMM:      begin valid = valid_op_imm; end
            `RV_OP_AUIPC:       begin valid = 1; end
            `RV_OP_OP_IMM_32:   begin valid = rv64 && valid_op_imm; end
            `RV_OP_STORE:       begin valid = insn[14] == 0 && insn[13:12] <= 2 + rv64; end
            `RV_OP_STORE_FP:    begin valid = 0; $strobe("TODO: validity for STORE_FP"); end
            `RV_OP_AMO:         begin valid = allow_a; end
            `RV_OP_OP:          begin valid = valid_op; end
            `RV_OP_LUI:         begin valid = 1; end
            `RV_OP_OP_32:       begin valid = rv64 && valid_op; end
            `RV_OP_MADD:        begin valid = 0; $strobe("TODO: validity for MADD"); end
            `RV_OP_MSUB:        begin valid = 0; $strobe("TODO: validity for MSUB"); end
            `RV_OP_NMSUB:       begin valid = 0; $strobe("TODO: validity for NMSUB"); end
            `RV_OP_NMADD:       begin valid = 0; $strobe("TODO: validity for NMADD"); end
            `RV_OP_OP_FP:       begin valid = 0; $strobe("TODO: validity for OP_FP"); end
            `RV_OP_BRANCH:      begin valid = insn[14] || !insn[13]; end
            `RV_OP_JALR:        begin valid = insn[14:12] == 0; end
            `RV_OP_JAL:         begin valid = 1; end
            `RV_OP_SYSTEM:      begin valid = valid_system; legal = legal_system; end
        endcase
    end
endmodule



// CSR write value helper.
module axo_csr_helper#(
    // XLEN; amount of bits stored in CSRs.
    parameter XLEN = 32
)(
    // CSR old value.
    input  logic[XLEN-1:0] old,
    // IMM or register value.
    input  logic[XLEN-1:0] bitmask,
    // FUNCT3 from SYSTEM opcode.
    input  logic[2:0]      funct3,
    // CSR new value.
    output logic[XLEN-1:0] dout
);
    always @(*) begin
        case (funct3)
            `RV_SYSTEM_CSRRC:  dout = old & ~bitmask;
            `RV_SYSTEM_CSRRCI: dout = old & ~bitmask;
            `RV_SYSTEM_CSRRS:  dout = old | bitmask;
            `RV_SYSTEM_CSRRSI: dout = old | bitmask;
            `RV_SYSTEM_CSRRW:  dout = bitmask;
            `RV_SYSTEM_CSRRWI: dout = bitmask;
            default: dout = 'bx;
        endcase
    end
endmodule
