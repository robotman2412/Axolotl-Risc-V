
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_defines.sv"

// Axolotl³² RV32IM_Zicsr processor.
// Pipeline: fetch, decode, execute
// Implemented CSRs: TODO.
// Interrupts: TODO.
// Privilege modes: M-mode only
module axo_rv32im_zicsr#(
    parameter entrypoint = 32'h4000_0000,
    parameter cpummio_addr = 32'hffff_ff00
)(
    // Clock source.
    input  wire clk,
    // Clock source for mtime.
    input  wire rtc_clk,
    // Reset signal.
    input  wire rst,
    // CPU ready to run code.
    // While this wire is LOW, the CPU is not available for debugging and does not run code.
    output wire ready,
    
    
    // Read from memory
    output wire       mem_re,
    // Write to memory.
    output wire       mem_we,
    // Memory access size in 2^n bytes.
    output wire[1:0]  mem_asize,
    // Memory ready: the CPU will stall on memory OPs while 0.
    input  wire       mem_ready,
    
    // Memory address bus.
    output wire[31:0] mem_addr,
    // Memory data bus.
    inout  wire[31:0] mem_data,
    
    
    // Read from program.
    output wire       prog_re,
    // Program ready: the CPU will stall loading instructions while 0.
    input  wire       prog_ready,
    
    // Program address bus.
    output wire[31:1] prog_addr,
    // Program data bus.
    input  wire[31:0] prog_data
    
    
    // TODO: Debug port.
);
    `include "axo_functions.sv"
    
    /* ==== WIRE AND REGISTER DEFINITIONS ==== */
    /* Miscellaneous logic */
    // Latched reset signal.
    reg         rst_latch;
    // Reset detect signal.
    reg         rst_detect;
    
    /* Pipeline hazard avoidance logic */
    // Stall IF stage.
    wire        fw_stall_if;
    // Stall ID stage.
    wire        fw_stall_id;
    // Stall EX stage.
    wire        fw_stall_ex;
    // Forward result to LHS.
    wire        fw_lhs;
    // Forward result to RHS.
    wire        fw_rhs;
    // Processing a jump or conditional branch.
    wire        fw_branch;
    // Branch prediction result.
    wire        fw_branch_predict;
    // Branch misprediction detected.
    wire        fw_branch_error;
    
    /* Pipeline stage 1/3: fetch */
    // IF: Instruction length.
    wire        if_len;
    // IF: Next instruction address.
    wire[31:1]  if_next_pc;
    // IF: Program counter.
    reg [31:1]  if_pc;
    // IF: Unpredicted path.
    reg [31:1]  if_alt_pc;
    
    /* Pipeline barrier: fetch/decode */
    // IF/ID: Contains valid decode state.
    reg         b_if_id_valid;
    // IF/ID: Current PC.
    reg [31:1]  b_if_id_pc;
    // IF/ID: Instruction length.
    reg         b_if_id_len;
    // IF/ID: Instruction word.
    reg [31:0]  b_if_id_insn;
    
    /* Pipeline stage 2/3: decode */
    // ID: CSR number or address offset.
    reg [11:0]  id_off;
    // ID: Branch target address.
    wire[31:1]  id_branch_addr;
    // ID: Instruction is jump or branch.
    wire        id_is_branch;
    // ID: Branch is predicted taken.
    wire        id_branch_predict;
    // ID: Instruction has RS1.
    wire        id_has_rs1;
    // ID: Instruction has RS2.
    wire        id_has_rs2;
    // ID: Instruction has RS3 (floating-point only).
    wire        id_has_rs3;
    // ID: Instruction has RD.
    wire        id_has_rd;
    // ID: RS1 register number.
    wire[4:0]   id_rs1;
    // ID: RS2 register number.
    wire[4:0]   id_rs2;
    // ID: RD register number.
    wire[4:0]   id_rd;
    // ID: Value of RS1.
    wire[31:0]  id_rs1_val;
    // ID: Value of RS2.
    wire[31:0]  id_rs2_val;
    // ID/EX: Left-hand side operand / RS1.
    reg [31:0]  id_lhs;
    // ID/EX: Right-hand side operand / RS2.
    reg [31:0]  id_rhs;
    
    /* Pipeline barrier: decode/execute */
    // ID/EX: Contains valid execution state.
    reg         b_id_ex_valid;
    // ID/EX: RS1 register number, or 0 if unused.
    reg [4:0]   b_id_ex_rs1;
    // ID/EX: RS2 register number, or 0 if unused.
    reg [4:0]   b_id_ex_rs2;
    // ID/EX: RD register number, or 0 if unused.
    reg [4:0]   b_id_ex_rd;
    // ID/EX: Left-hand side operand / RS1.
    reg [31:0]  b_id_ex_lhs;
    // ID/EX: Right-hand side operand / RS2.
    reg [31:0]  b_id_ex_rhs;
    // ID/EX: CSR number or address offset.
    reg [11:0]  b_id_ex_off;
    // ID/EX: Instruction word.
    reg [31:0]  b_id_ex_insn;
    // ID/EX: Memory read enable.
    reg         b_id_ex_mem_re;
    // ID/EX: Memory write enable.
    reg         b_id_ex_mem_we;
    // ID/EX: Memory access size in 2^n bytes.
    reg [1:0]   b_id_ex_mem_asize;
    // ID/EX: Branch predictor result.
    reg         b_id_ex_branch_predict;
    
    /* Pipeline stage 3/3: execute */
    // EX: Contains valid result.
    wire        ex_valid;
    // EX: ALU result.
    wire[31:0]  ex_alu_res;
    // EX: Memory address.
    wire[31:0]  ex_addr;
    // EX: Destrination register.
    wire[4:0]   ex_rd;
    // EX: Result to write back to registers.
    reg [31:0]  ex_result;
    // EX: Instruction is a conditional branch.
    wire        ex_is_branch;
    // EX: Conditional branch result.
    wire        ex_branch_taken;
    // EX: Conditional branch was mispredicted.
    wire        ex_branch_error;
    
    
    
    /* ==== MISCELLANEOUS LOGIC ==== */
    // Reset signal logic.
    assign ready = !rst_latch;
    
    initial begin
        rst_latch <= 1;
    end
    
    always @(*) begin
        if (rst) begin
            rst_latch <= 1;
        end else if (rst_detect && !clk) begin
            rst_latch <= 0;
        end
    end
    
    always @(posedge clk) begin
        rst_detect <= rst_latch;
    end
    
    
    
    /* ==== PIPELINE HAZARD AVOIDANCE LOGIC ==== */
    // Forwarding logic.
    assign fw_lhs            = b_id_ex_valid && b_id_ex_rd != 0 && b_id_ex_rd == id_rs1 && id_has_rs1;
    assign fw_rhs            = b_id_ex_valid && b_id_ex_rd != 0 && b_id_ex_rd == id_rs2 && id_has_rs2;
    assign fw_stall_if       = 0;
    assign fw_stall_id       = 0;
    assign fw_stall_ex       = 0;
    assign fw_branch         = !fw_branch_error && id_is_branch;
    assign fw_branch_predict = !fw_branch_error && id_branch_predict;
    assign fw_branch_error   = ex_branch_error;
    
    
    /* ==== PIPELINE STAGE 1/3: FETCH ==== */
    // Instruction length decoder.
    assign if_len       = axo_insn_length(prog_data);
    // Next instruction address.
    assign if_next_pc   = if_pc + (if_len ? 4 : 2);
    
    // Instruction bus logic.
    assign prog_addr    = if_pc;
    assign prog_re      = !fw_stall_if;
    
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            if_pc     <= entrypoint;
            if_alt_pc <= 0;
        end else if (!fw_stall_if) begin
            // Next PC.
            if (fw_branch_error) begin
                if_pc <= if_alt_pc;
            end else if (id_is_branch && fw_branch_predict) begin
                if_pc <= id_branch_addr;
            end else begin
                if_pc <= if_next_pc;
            end
            // Unpredicted path.
            if (id_is_branch && fw_branch_predict) begin
                if_alt_pc <= if_pc;
            end else if (id_is_branch) begin
                if_alt_pc <= id_branch_addr;
            end
        end
    end
    
    
    
    /* ==== PIPELINE BARRIER: FETCH/DECODE ==== */
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            b_if_id_valid   <= 0;
            b_if_id_len     <= 0;
            b_if_id_pc      <= 0;
            b_if_id_insn    <= 0;
        end else if (!fw_stall_if) begin
            // Discard loaded insn on branch error.
            b_if_id_valid   <= !(fw_branch && fw_branch_predict) && !fw_branch_error;
            // Latch loaded instruction data.
            b_if_id_len     <= if_len;
            b_if_id_pc      <= if_pc;
            // TODO: Decompress RVC instructions.
            b_if_id_insn    <= prog_data;
        end else begin
            // Stalled; results are invalid.
            b_if_id_valid   <= 0;
        end
    end
    
    
    
    /* ==== PIPELINE STAGE 2/3: DECODE ==== */
    assign id_rs1 = axo_insn_rs1(b_if_id_insn);
    assign id_rs2 = axo_insn_rs2(b_if_id_insn);
    assign id_rd  = axo_insn_rd(b_if_id_insn);
    axo_regfile regs(
        clk, rst,
        ex_rd, axo_insn_rs1(b_if_id_insn), axo_insn_rs2(b_if_id_insn),
        !fw_stall_id && ex_valid,
        ex_result, id_rs1_val, id_rs2_val
    );
    
    // CSR number / address offset logic.
    always @(*) begin
        if (axo_insn_opcode(b_if_id_insn) == `RV_OP_SYSTEM && axo_insn_funct3(b_if_id_insn) != `RV_SYSTEM_ECALL) begin
            // CSR number.
            id_off          <= b_if_id_insn[31:20];
            
        end else if (axo_insn_opcode(b_if_id_insn) & ~1 == `RV_OP_LOAD) begin
            // Memory load offset.
            id_off          <= b_if_id_insn[31:20];
            
        end else /*if (axo_insn_opcode(b_if_id_insn) & ~1 == `RV_OP_STORE)*/ begin
            // Memory store offset.
            id_off[11:5]    <= b_if_id_insn[31:25];
            id_off[4:0]     <= b_if_id_insn[11:7];
        end
    end
    
    // Branch prediction logic.
    assign id_is_branch      = b_if_id_valid && axo_insn_is_branch(b_if_id_insn);
    assign id_branch_predict = axo_insn_opcode(b_if_id_insn) != `RV_OP_BRANCH || b_if_id_insn[31];
    
    // Branch target address logic.
    axo_branch_target branch_target(
        b_if_id_insn,
        b_if_id_pc, fw_lhs ? ex_result : id_rs1_val,
        id_branch_addr
    );
    
    // RS1/RS2/RSD presence decoder.
    axo_reg_decoder has_regs(
        b_if_id_insn,
        id_has_rs1, id_has_rs2, id_has_rs3, id_has_rd
    );
    
    // LHS/RHS generation logic.
    always @(*) begin
        if (b_if_id_insn[6:2] ==? 5'b110x1) begin
            // PC for JALs.
            id_lhs <= b_if_id_pc;
            
        end else if (axo_insn_opcode(b_if_id_insn) == `RV_OP_AUIPC) begin
            // PC for AUIPC.
            id_lhs <= b_if_id_pc;
            
        end else if (axo_insn_opcode(b_if_id_insn) == `RV_OP_LUI) begin
            // Zero for LUI.
            id_lhs <= 0;
            
        end else begin
            // Register value.
            id_lhs <= fw_lhs ? ex_result : id_rs1_val;
        end
    end
    
    always @(*) begin
        if (b_if_id_insn[6:2] ==? 5'b110x1) begin
            // Instruction length for JALs.
            id_rhs  <= b_if_id_len ? 4 : 2;
            
        end else if (b_if_id_insn[6:2] ==? 5'b0x101) begin
            // IMM for AUIPC / LUI.
            id_rhs[11:0]    <= 0;
            id_rhs[31:12]   <= b_if_id_insn[31:12];
            
        end else if (axo_insn_is_alu_imm(b_if_id_insn)) begin
            // IMM for ALU ops.
            id_rhs[11:0]    <= b_if_id_insn[31:20];
            id_rhs[31:12]   <= b_if_id_insn[31] ? 20'hfffff : 20'h00000;
            
        end else begin
            // Register value.
            id_rhs  <= fw_rhs ? ex_result : id_rs2_val;
        end
    end
    
    
    
    /* ==== PIPELINE BARRIER: DECODE/EXECUTE ==== */
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            b_id_ex_valid           <= 0;
            b_id_ex_rs1             <= 0;
            b_id_ex_rs2             <= 0;
            b_id_ex_rd              <= 0;
            b_id_ex_lhs             <= 0;
            b_id_ex_rhs             <= 0;
            b_id_ex_off             <= 0;
            b_id_ex_insn            <= 0;
            b_id_ex_mem_re          <= 0;
            b_id_ex_mem_we          <= 0;
            b_id_ex_mem_asize       <= 0;
            b_id_ex_branch_predict  <= 0;
        end else if (!fw_stall_id) begin
            // Discard decoded insn on branch error or if loaded insn is bad.
            b_id_ex_valid           <= b_if_id_valid && !fw_branch_error;
            // Latch decoded instruction data.
            b_id_ex_rs1             <= id_has_rs1 ? id_rs1 : 0;
            b_id_ex_rs2             <= id_has_rs2 ? id_rs2 : 0;
            b_id_ex_rd              <= id_has_rd ? id_rd : 0;
            b_id_ex_lhs             <= id_lhs;
            b_id_ex_rhs             <= id_rhs;
            b_id_ex_off             <= id_off;
            b_id_ex_insn            <= b_if_id_insn;
            // TODO: Memory access logic.
            b_id_ex_mem_re          <= 0;
            b_id_ex_mem_we          <= 0;
            b_id_ex_mem_asize       <= 0;
            // Latch branch prediction for possible correction.
            b_id_ex_branch_predict  <= id_branch_predict;
        end else begin
            // Stalled; results are invalid.
            b_id_ex_valid           <= 0;
        end
    end
    
    
    
    /* ==== PIPELINE STAGE 3/3: EXECUTE ==== */
    assign ex_valid = b_id_ex_valid && !fw_stall_ex;
    assign ex_rd    = b_id_ex_rd;
    
    // ALU logic.
    axo32_alu_rv32im alu(
        b_id_ex_insn, b_id_ex_lhs, b_id_ex_rhs,
        ex_alu_res, ex_addr
    );
    
    // Definitive branch results.
    assign ex_is_branch    = ex_valid && axo_insn_opcode(b_id_ex_insn) == `RV_OP_BRANCH;
    assign ex_branch_taken = ex_alu_res[0];
    assign ex_branch_error = ex_is_branch && ex_branch_taken != b_id_ex_branch_predict;
    
    // Memory access logic.
    assign mem_we    = ex_valid && b_id_ex_mem_we;
    assign mem_re    = ex_valid && b_id_ex_mem_re;
    assign mem_data  = mem_we ? b_id_ex_rhs : 'bz;
    assign mem_asize = b_id_ex_mem_asize;
    assign mem_addr  = ex_addr;
    
    // TODO: CSR regfile.
    
    // Result logic.
    always @(*) begin
        if (b_id_ex_mem_re || b_id_ex_mem_we) begin
            // Memory access instruction.
            ex_result <= mem_data;
        end else if (0) begin
            // TODO: CSR access instruction.
            ex_result <= 0;
        end else begin
            // ALU things.
            ex_result <= ex_alu_res;
        end
    end
    
endmodule
