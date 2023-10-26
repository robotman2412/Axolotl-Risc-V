
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ns
`include "axo_defines.sv"

/*
    Axolotl³² RV32IM_Zicsr processor.
    
    Pipeline: fetch, decode, execute
    IPC: 0.33 min, 0.80 avg, 1.00 max
    
    IALIGN: 32
    Interrupts: 16 external, 1 internal
    Privilege modes: M-mode only
    
    Implemented CSRs:
        0x300   mstatus
        0x301   misa        (RV32IM)
        0x302   medeleg     (0)
        0x303   mideleg     (0)
        0x304   mie
        0x305   mtvec
        0x310   mstatush    (0)
        
        0x344   mip
        0x340   mscratch
        0x341   mepc
        0x342   mcause
        0x343   mtval (0)
        
        0xf11   mvendorid   (0)
        0xf12   marchid     (0)
        0xf13   mipid       (0)
        0xf14   mhartid     (parameter)
        0xf15   mconfigptr  (0)
*/
module axo_rv32im_zicsr#(
    parameter entrypoint   = 32'h4000_0000,
    parameter cpummio_addr = 32'hffff_ff00,
    parameter mhartid      = 32'h0000_0000
)(
    // Clock source.
    input  logic clk,
    // Clock source for mtime.
    input  logic rtc_clk,
    // Reset signal.
    input  logic rst,
    // CPU ready to run code.
    // While this wire is LOW, the CPU is not available for debugging and does not run code.
    output logic ready,
    
    
    // Memory access port.
    axo_mem_bus.CPU mem,
    // Program memory access port.
    axo_mem_bus.CPU prog,
    
    
    // External interrupts 16 to 31.
    input  logic[15:0] irq
    
    
    // TODO: Debug port.
);
    `include "axo_functions.sv"
    
    /* ==== WIRE AND REGISTER DEFINITIONS ==== */
    /* Miscellaneous logic */
    // Latched reset signal.
    reg         rst_latch;
    // Reset detect signal.
    reg         rst_detect;
    
    /* Exception logic */
    // Exception from EX stage.
    logic       tr_ex;
    // EX exception cause.
    logic[4:0]  tr_ex_cause;
    // Interrupts pending.
    wire [31:0] tr_irq = irq << 16;
    // Interrupt or trap raised.
    logic       tr_trap;
    // Interrupt or trap cause.
    logic[4:0]  tr_trap_cause;
    // Is an interrupt.
    logic       tr_is_interrupt;
    // Interrupt enabled mask.
    logic[31:0] tr_ie;
    // Interrupt vector.
    logic[31:2] tr_vec;
    // Trap return address.
    logic[31:1] tr_ret_addr;
    
    /* Pipeline hazard avoidance logic */
    // Stall IF stage.
    logic       fw_stall_if;
    // Stall ID stage.
    logic       fw_stall_id;
    // Stall EX stage.
    logic       fw_stall_ex;
    // Stall IF stage due to memory.
    logic       fw_stall_if_mem;
    // Stall ID stage due to memory.
    logic       fw_stall_id_mem;
    // Stall EX stage due to memory.
    logic       fw_stall_ex_mem;
    // Forward result to LHS.
    logic       fw_lhs;
    // Forward result to RHS.
    logic       fw_rhs;
    // Processing a jump or conditional branch.
    logic       fw_branch;
    // Branch prediction result.
    logic       fw_branch_predict;
    // Branch misprediction detected.
    logic       fw_branch_error;
    
    /* Pipeline stage 1/3: fetch */
    // IF: Instruction length.
    logic       if_len;
    // IF: Next instruction address.
    logic[31:1] if_next_pc;
    // IF: Program counter.
    reg  [31:1] if_pc;
    // IF: Unpredicted path.
    reg  [31:1] if_alt_pc;
    // IF: Dispatch trap.
    logic       if_trap;
    // IF: Trap cause.
    logic[4:0]  if_cause;
    
    /* Pipeline barrier: fetch/decode */
    // IF/ID: Contains valid decode state.
    reg         b_if_id_valid;
    // IF/ID: Current PC.
    reg  [31:1] b_if_id_pc;
    // IF/ID: Instruction length.
    reg         b_if_id_len;
    // IF/ID: Instruction word.
    reg  [31:0] b_if_id_insn;
    // IF/ID: Trap dispatched.
    // Exempt from b_if_id_valid.
    reg         b_if_id_trap;
    // IF/ID: Trap cause.
    // Exempt from b_if_id_valid.
    reg  [4:0]  b_if_id_cause;
    
    /* Pipeline stage 2/3: decode */
    // ID: CSR number or address offset.
    logic[11:0] id_off;
    // ID: Branch target address.
    logic[31:1] id_branch_addr;
    // ID: Instruction is jump or branch.
    logic       id_is_branch;
    // ID: Branch is predicted taken.
    logic       id_branch_predict;
    // ID: Instruction is valid.
    logic       id_insn_valid;
    // ID: Instruction is legal in current privilege mode.
    logic       id_insn_legal;
    // ID: Instruction has RS1.
    logic       id_has_rs1;
    // ID: Instruction has RS2.
    logic       id_has_rs2;
    // ID: Instruction has RS3 (floating-point only).
    logic       id_has_rs3;
    // ID: Instruction has RD.
    logic       id_has_rd;
    // ID: RS1 register number.
    logic[4:0]  id_rs1;
    // ID: RS2 register number.
    logic[4:0]  id_rs2;
    // ID: RD register number.
    logic[4:0]  id_rd;
    // ID: Value of RS1.
    logic[31:0] id_rs1_val;
    // ID: Value of RS2.
    logic[31:0] id_rs2_val;
    // ID: Left-hand side operand / RS1.
    logic[31:0] id_lhs;
    // ID: Right-hand side operand / RS2.
    logic[31:0] id_rhs;
    // ID: Dispatch trap.
    logic       id_trap;
    // ID: Trap cause.
    logic[4:0]  id_cause;
    
    /* Pipeline barrier: decode/execute */
    // ID/EX: Contains valid execution state.
    reg         b_id_ex_valid;
    // ID/EX: RD register number, or 0 if unused.
    reg  [4:0]  b_id_ex_rd;
    // ID/EX: Left-hand side operand / RS1.
    reg  [31:0] b_id_ex_lhs;
    // ID/EX: Right-hand side operand / RS2.
    reg  [31:0] b_id_ex_rhs;
    // ID/EX: CSR number or address offset.
    reg  [11:0] b_id_ex_off;
    // ID/EX: Current PC.
    reg  [31:1] b_id_ex_pc;
    // ID/EX: Instruction word.
    reg  [31:0] b_id_ex_insn;
    // ID/EX: Branch predictor result.
    reg         b_id_ex_branch_predict;
    // ID/EX: Trap dispatched.
    // Exempt from b_id_ex_valid.
    reg         b_id_ex_trap;
    // ID/EX: Trap cause.
    // Exempt from b_id_ex_valid.
    reg  [4:0]  b_id_ex_cause;
    
    /* Pipeline stage 3/3: execute */
    // EX: Contains valid result.
    logic       ex_valid;
    // EX: ALU result.
    logic[31:0] ex_alu_res;
    // EX: CSR write enable.
    logic       ex_csr_we;
    // EX: CSR write data.
    logic[31:0] ex_csr_din;
    // EX: CSR result.
    logic[31:0] ex_csr_res;
    // EX: Memory address.
    logic[31:0] ex_addr;
    // EX: Destrination register.
    logic[4:0]  ex_rd;
    // EX: Result to write back to registers.
    logic[31:0] ex_result;
    // EX: Instruction is memory access.
    logic       ex_is_mem;
    // EX: Instruction is a conditional branch.
    logic       ex_is_branch;
    // EX: Conditional branch result.
    logic       ex_branch_taken;
    // EX: Conditional branch was mispredicted.
    logic       ex_branch_error;
    // EX: Trap caused by CSR access.
    logic       ex_csr_trap;
    // EX: Dispatch trap.
    logic       ex_trap;
    // EX: Trap cause.
    logic[4:0]  ex_cause;
    
    
    
    /* ==== MISCELLANEOUS LOGIC ==== */
    // Reset signal logic.
    assign ready = !rst_latch;
    
    initial begin
        rst_latch = 1;
    end
    
    always @(posedge rst, negedge clk) begin
        if (rst) begin
            rst_latch <= 1;
        end else if (rst_detect && !clk) begin
            rst_latch <= 0;
        end
    end
    
    always @(posedge clk) begin
        rst_detect <= rst_latch;
    end
    
    
    
    /* ==== EXCEPTION LOGIC ==== */
    // Get traps from EX stage.
    assign tr_ex        = b_id_ex_trap || ex_trap;
    assign tr_ex_cause  = b_id_ex_trap ? b_id_ex_cause : ex_cause;
    
    // Trap and interrupt detection.
    integer irq_no;
    always @(*) begin
        if (tr_ex) begin
            // Prioritise traps over interrupts.
            tr_trap         = 1;
            tr_trap_cause   = tr_ex_cause;
            tr_is_interrupt = 0;
            
        end else if (tr_irq & tr_ie) begin
            // Prioritise the lowest numbered interrupt.
            tr_trap         = 0;
            tr_trap_cause   = 'bx;
            tr_is_interrupt = 1;
            for (irq_no = 31; irq_no >= 0; irq_no = irq_no - 1) begin
                if (tr_ie[irq_no] && tr_irq[irq_no]) begin
                    tr_trap = 1;
                    tr_trap_cause = irq_no;
                end
            end
        end else begin
            tr_trap         = 0;
            tr_trap_cause   = 'bx;
            tr_is_interrupt = 'bx;
        end
    end
    
    
    
    /* ==== PIPELINE HAZARD AVOIDANCE LOGIC ==== */
    // Forwarding logic.
    assign fw_lhs            = b_id_ex_valid && b_id_ex_rd != 0 && b_id_ex_rd == id_rs1 && id_has_rs1;
    assign fw_rhs            = b_id_ex_valid && b_id_ex_rd != 0 && b_id_ex_rd == id_rs2 && id_has_rs2;
    assign fw_branch         = !fw_branch_error && id_is_branch;
    assign fw_branch_predict = !fw_branch_error && id_branch_predict;
    assign fw_branch_error   = ex_branch_error;
    assign fw_stall_ex       = 0;
    always @(*) begin
        if (b_if_id_valid && axo_insn_is_xret(b_if_id_insn) && b_if_id_valid && !b_if_id_trap && axo_insn_is_csr(b_id_ex_insn)) begin
            // MRET is vulnerable to CSR writes, stall it.
            fw_stall_id = 1;
        end else if (fw_stall_ex || fw_stall_ex_mem) begin
            fw_stall_id = 1;
        end else begin
            fw_stall_id = 0;
        end
    end
    assign fw_stall_if       = fw_stall_id;
    
    assign fw_stall_ex_mem   = (mem.re || mem.we) && !mem.ready;
    assign fw_stall_id_mem   = 0;
    assign fw_stall_if_mem   = (prog.re && !prog.ready);
    
    /* ==== PIPELINE STAGE 1/3: FETCH ==== */
    // Instruction length decoder.
    assign if_len       = 1;
    // Next instruction address.
    assign if_next_pc   = if_pc + (if_len ? 4 : 2);
    
    // Instruction bus logic.
    assign prog.re      = !fw_stall_if;
    assign prog.we      = 0;
    assign prog.asize   = 2;
    assign prog.addr    = if_pc;
    assign prog.wdata   = 0;
    
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            if_pc     <= entrypoint;
            if_alt_pc <= 0;
        end else if (!fw_stall_if && !fw_stall_if_mem) begin
            // Next PC.
            if (tr_trap) begin
                if_pc <= tr_vec;
            end else if (fw_branch_error) begin
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
    
    // Trap logic.
    assign if_trap  = if_pc[1] || (prog.ready && prog.error);
    assign if_cause = if_pc[1] ? `RV_ECAUSE_IALIGN : `AXO_ECAUSE_IMFAULT;
    
    
    
    /* ==== PIPELINE BARRIER: FETCH/DECODE ==== */
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            b_if_id_valid   <= 0;
            b_if_id_len     <= 0;
            b_if_id_pc      <= 0;
            b_if_id_insn    <= 0;
            b_if_id_trap    <= 0;
            b_if_id_cause   <= 0;
        end else if (!fw_stall_if && !fw_stall_if_mem) begin
            // Discard loaded insn on branch error.
            b_if_id_valid   <= !(fw_branch && fw_branch_predict) && !fw_branch_error && !tr_trap;
            // Latch loaded instruction data.
            b_if_id_len     <= if_len;
            b_if_id_pc      <= if_pc;
            b_if_id_insn    <= prog.rdata;
            // Trap information.
            b_if_id_trap    <= if_trap;
            b_if_id_cause   <= if_cause;
        end else if (!fw_stall_id && !fw_stall_id_mem) begin
            // Stalled; results are invalid.
            b_if_id_valid   <= 0;
        end
    end
    
    
    
    /* ==== PIPELINE STAGE 2/3: DECODE ==== */
    // Instruction validator.
    axo_insn_validator#(.has_m(1)) validator(
        b_if_id_insn, 2'b11, 1'b0, 32'hffff_ffff,
        id_insn_valid, id_insn_legal
    );
    
    always @(negedge clk) begin
        if (!rst_latch && b_if_id_valid) begin
            if (!id_insn_valid) begin
                $strobe("ID: %08x: Invalid instruction", b_if_id_insn);
            end else if (!id_insn_legal) begin
                $strobe("ID: %08x: No permission for instruction", b_if_id_insn);
            end else begin
                $strobe("ID: %08x: OK", b_if_id_insn);
            end
        end
    end
    
    // Register file.
    assign id_rs1 = axo_insn_rs1(b_if_id_insn);
    assign id_rs2 = axo_insn_rs2(b_if_id_insn);
    assign id_rd  = axo_insn_rd(b_if_id_insn);
    axo_regfile regs(
        clk, rst,
        ex_rd, axo_insn_rs1(b_if_id_insn), axo_insn_rs2(b_if_id_insn),
        !fw_stall_ex && !fw_stall_ex_mem && ex_valid,
        ex_result, id_rs1_val, id_rs2_val
    );
    
    // CSR number / address offset logic.
    always @(*) begin
        if (axo_insn_opcode(b_if_id_insn) == `RV_OP_SYSTEM && axo_insn_funct3(b_if_id_insn) != `RV_SYSTEM_ECALL) begin
            // CSR number.
            id_off          = b_if_id_insn[31:20];
            
        end else if (axo_insn_opcode(b_if_id_insn) == `RV_OP_LOAD) begin
            // Memory load offset.
            id_off          = b_if_id_insn[31:20];
            
        end else /*if (axo_insn_opcode(b_if_id_insn) == `RV_OP_STORE)*/ begin
            // Memory store offset.
            id_off[11:5]    = b_if_id_insn[31:25];
            id_off[4:0]     = b_if_id_insn[11:7];
        end
    end
    
    // Branch prediction logic.
    always @(*) begin
        if (b_if_id_valid && axo_insn_opcode(b_if_id_insn) == `RV_OP_BRANCH) begin
            // BRANCH.
            id_is_branch      = 1;
            id_branch_predict = b_if_id_insn[31];
        end else if (b_if_id_valid && axo_insn_is_branch(b_if_id_insn)) begin
            // JAL / JALR.
            id_is_branch      = 1;
            id_branch_predict = 1;
        end else if (b_if_id_valid && axo_insn_is_xret(b_if_id_insn)) begin
            // MRET.
            id_is_branch      = 1;
            id_branch_predict = 1;
        end else begin
            // Not a control transfer.
            id_is_branch      = 0;
            id_branch_predict = 'bx;
        end
    end
    
    // Branch target address logic.
    axo_branch_target branch_target(
        b_if_id_insn,
        b_if_id_pc, tr_ret_addr, fw_lhs ? ex_result : id_rs1_val,
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
            id_lhs = b_if_id_pc;
            
        end else if (axo_insn_opcode(b_if_id_insn) == `RV_OP_AUIPC) begin
            // PC for AUIPC.
            id_lhs = b_if_id_pc;
            
        end else if (axo_insn_opcode(b_if_id_insn) == `RV_OP_LUI) begin
            // Zero for LUI.
            id_lhs = 0;
            
        end else begin
            // Register value.
            id_lhs = fw_lhs ? ex_result : id_rs1_val;
        end
    end
    
    always @(*) begin
        if (b_if_id_insn[6:2] ==? 5'b110x1) begin
            // Instruction length for JALs.
            id_rhs          = b_if_id_len ? 4 : 2;
            
        end else if (b_if_id_insn[6:2] ==? 5'b0x101) begin
            // IMM for AUIPC / LUI.
            id_rhs[11:0]    = 0;
            id_rhs[31:12]   = b_if_id_insn[31:12];
            
        end else if (axo_insn_is_alu_imm(b_if_id_insn)) begin
            // IMM for ALU ops.
            id_rhs[11:0]    = b_if_id_insn[31:20];
            id_rhs[31:12]   = b_if_id_insn[31] ? 20'hfffff : 20'h00000;
            
        end else begin
            // Register value.
            id_rhs          = fw_rhs ? ex_result : id_rs2_val;
        end
    end
    
    // Trap logic.
    assign id_trap  = b_if_id_valid && !id_insn_valid;
    assign id_cause = `RV_ECAUSE_IILLEGAL;
    
    
    
    /* ==== PIPELINE BARRIER: DECODE/EXECUTE ==== */
    always @(posedge clk) begin
        if (rst_latch) begin
            // Reset.
            b_id_ex_valid           <= 0;
            b_id_ex_rd              <= 0;
            b_id_ex_lhs             <= 0;
            b_id_ex_rhs             <= 0;
            b_id_ex_off             <= 0;
            b_id_ex_pc              <= 0;
            b_id_ex_insn            <= 0;
            b_id_ex_branch_predict  <= 0;
            b_id_ex_trap            <= 0;
            b_id_ex_cause           <= 0;
        end else if (!fw_stall_id && !fw_stall_id_mem) begin
            // Discard decoded insn on branch error or if loaded insn is bad.
            b_id_ex_valid           <= b_if_id_valid && !fw_branch_error && !tr_trap;
            // Latch decoded instruction data.
            b_id_ex_rd              <= id_has_rd ? id_rd : 0;
            b_id_ex_lhs             <= id_lhs;
            b_id_ex_rhs             <= id_rhs;
            b_id_ex_off             <= id_off;
            b_id_ex_pc              <= b_if_id_pc;
            b_id_ex_insn            <= b_if_id_insn;
            // Latch branch prediction for possible correction.
            b_id_ex_branch_predict  <= id_branch_predict;
            // Trap information.
            b_id_ex_trap            <= b_if_id_trap || id_trap;
            b_id_ex_cause           <= b_if_id_trap ? b_if_id_cause : id_cause;
        end else if (!fw_stall_ex && !fw_stall_ex_mem) begin
            // Stalled; results are invalid.
            b_id_ex_valid           <= 0;
        end
    end
    
    
    
    /* ==== PIPELINE STAGE 3/3: EXECUTE ==== */
    assign ex_valid = b_id_ex_valid && !tr_trap;
    assign ex_rd    = b_id_ex_rd;
    
    // ALU logic.
    axo32_alu_rv32im alu(
        b_id_ex_insn, b_id_ex_lhs, ex_is_mem ? b_id_ex_off : b_id_ex_rhs,
        ex_alu_res, ex_addr
    );
    
    // Definitive branch results.
    assign ex_is_branch    = ex_valid && axo_insn_opcode(b_id_ex_insn) == `RV_OP_BRANCH;
    assign ex_branch_taken = ex_alu_res[0];
    assign ex_branch_error = ex_is_branch && ex_branch_taken != b_id_ex_branch_predict;
    
    // Memory access logic.
    assign ex_is_mem = b_id_ex_valid && (axo_insn_opcode(b_id_ex_insn) == `RV_OP_STORE || axo_insn_opcode(b_id_ex_insn) == `RV_OP_LOAD);
    assign mem.we    = b_id_ex_valid && !b_id_ex_trap && axo_insn_opcode(b_id_ex_insn) == `RV_OP_STORE;
    assign mem.re    = b_id_ex_valid && !b_id_ex_trap && axo_insn_opcode(b_id_ex_insn) == `RV_OP_LOAD;
    assign mem.wdata = b_id_ex_rhs;
    assign mem.asize = b_id_ex_insn[13:12];
    assign mem.addr  = ex_addr;
    
    // CSR access logic.
    always @(*) begin
        if (axo_insn_opcode(b_id_ex_insn) != `RV_OP_SYSTEM || axo_insn_funct3(b_id_ex_insn) == 0) begin
            ex_csr_we = 0;
        end else begin
            ex_csr_we = !b_id_ex_insn[13] || (axo_insn_rs1(b_id_ex_insn) != 0);
        end
    end
    
    axo_csr_helper csr_io(
        ex_csr_res, b_id_ex_insn[14] ? axo_insn_rs1(b_id_ex_insn) : b_id_ex_lhs, axo_insn_funct3(b_id_ex_insn), ex_csr_din
    );
    
    axo_rv32im_zicsr_csrs#(mhartid) csrs(
        clk, rst_latch,
        b_id_ex_off, ex_csr_din, ex_csr_res, ex_csr_we, ex_csr_trap,
        tr_irq, b_id_ex_pc, tr_trap_cause, tr_trap, tr_is_interrupt,
        tr_ie, tr_vec, tr_ret_addr
    );
    
    // Result logic.
    always @(*) begin
        if (ex_is_mem) begin
            // Memory access instruction.
            case (mem.asize)
                0:  begin
                    ex_result[7:0]  = mem.rdata[7:0];
                    ex_result[31:8] = mem.rdata[7] && b_id_ex_insn[14] ? 24'hffffff : 24'h000000;
                end
                1:  begin
                    ex_result[15:0]  = mem.rdata[15:0];
                    ex_result[31:16] = mem.rdata[15] && b_id_ex_insn[14] ? 16'hffff : 16'h0000;
                end
                2:  ex_result = mem.rdata;
                3:  ex_result = 'bx;
            endcase
        end else if (axo_insn_opcode(b_id_ex_insn) == `RV_OP_SYSTEM && axo_insn_funct3(b_id_ex_insn) != 0) begin
            // CSR access instruction.
            ex_result = ex_csr_res;
        end else begin
            // ALU things.
            ex_result = ex_alu_res;
        end
    end
    
    // Trap logic.
    always @(*) begin
        if (b_id_ex_valid) begin
            if (axo_insn_opcode(b_id_ex_insn) == `RV_OP_SYSTEM && axo_insn_funct3(b_id_ex_insn) != 0 && ex_csr_trap) begin
                // CSR trap.
                ex_trap  = 1;
                ex_cause = `RV_ECAUSE_IILLEGAL;
                
            end else if (axo_insn_opcode(b_id_ex_insn) == `RV_OP_STORE && mem.error) begin
                // Memory store access fault.
                ex_trap  = 1;
                ex_cause = mem.rdata[3:0] == `AXO_MEM_EALIGN ? `RV_ECAUSE_SALIGN : `AXO_ECAUSE_LMFAULT;
                
            end else if (axo_insn_opcode(b_id_ex_insn) == `RV_OP_LOAD && mem.error) begin
                // Memory load access fault.
                ex_trap  = 1;
                ex_cause = mem.rdata[3:0] == `AXO_MEM_EALIGN ? `RV_ECAUSE_LALIGN : `AXO_ECAUSE_SMFAULT;
                
            end else begin
                ex_trap  = 0;
                ex_cause = 'bx;
            end
        end else begin
            ex_trap  = 0;
            ex_cause = 'bx;
        end
    end
endmodule



// CSR register file for Axolotl³² RV32IM_Zicsr processor.
// This register file is implementation-specific.
module axo_rv32im_zicsr_csrs#(
    parameter mhartid = 32'h0000_0000
)(
    // Clock.
    input  logic         clk,
    // Reset.
    input  logic         rst,
    
    // CSR address.
    input  logic[11:0]   addr,
    // CSR write data.
    input  logic[31:0]   din,
    // CSR read data.
    output logic[31:0]   dout,
    // CSR write enable.
    input  logic         we,
    // Illegal or invalid CSR access.
    output logic         invalid,
    
    // Current interrupts pending.
    input  logic[31:0]   mip,
    // Program counter to save on trap or interrupt.
    input  logic[31:1]   mepc_in,
    // Cause of interrupt / trap being dispatched.
    input  logic[4:0]    cause,
    // Trap or interrupt dispatched.
    input  logic         trap,
    // Is an interrupt.
    input  logic         is_int,
    
    // Current interrupts enabled, masked by CSR mie and CSR mstatus.
    output logic[31:0]   mie,
    // Current trap and interrupt vector.
    output logic[31:2]   mtvec,
    // Current exception PC.
    output logic[31:1]   mepc_out
);
    /* ==== CSR STORAGE ==== */
    // CSR mstatus: M-mode previous interrupt enable.
    logic        csr_mstatus_mpie;
    // CSR mstatus: M-mode interrupt enable.
    logic        csr_mstatus_mie;
    // CSR mcause: Interrupt number / trap number.
    logic[4:0]   csr_mcause_no;
    // CSR mcause: Is an interrupt.
    logic        csr_mcause_int;
    
    // CSR mstatus: M-mode status.
    wire [31:0] csr_mstatus     = (csr_mstatus_mie << 3) | (csr_mstatus_mpie << 7);
    // CSR misa: M-mode ISA description.
    wire [31:0] csr_misa        = 32'h4001_0100;
    // CSR medeleg: M-mode trap delegation.
    wire [31:0] csr_medeleg     = 0;
    // CSR medeleg: M-mode interrupt delegation.
    wire [31:0] csr_mideleg     = 0;
    // CSR mie: M-mode per-interrupt enable.
    reg  [31:0] csr_mie;
    // CSR mtvec: M-mode trap and interrupt vector.
    reg  [31:2] csr_mtvec;
    // CSR mstatush: M-mode status.
    wire [31:0] csr_mstatush    = 0;
    // CSR mip: M-mode interrupts pending.
    wire [31:0] csr_mip         = mip;
    // CSR mscratch: M-mode scratch pad register.
    reg  [31:0] csr_mscratch;
    // CSR mepc: M-mode exception program counter.
    reg  [31:1] csr_mepc;
    // CSR mcause: M-mode interrupt / trap cause.
    wire [31:0] csr_mcause      = (csr_mcause_int << 31) | csr_mcause_int;
    // CSR mtval: M-mode trap value.
    wire [31:0] csr_mtval       = 0;
    // CSR mvendorid: M-mode vendor ID.
    wire [31:0] csr_mvendorid   = 0;
    // CSR mvendorid: M-mode architecture ID.
    wire [31:0] csr_marchid     = 0;
    // CSR mvendorid: M-mode implementation ID.
    wire [31:0] csr_mipid       = 0;
    // CSR mvendorid: M-mode implementation ID.
    wire [31:0] csr_mhartid     = mhartid;
    // CSR mvendorid: M-mode configuration pointer.
    wire [31:0] csr_mconfigptr  = 0;
    
    
    
    /* ==== MISCELLANEOUS LOGIC ==== */
    // CSR exists.
    logic       csr_exists;
    // CSR is writeable.
    logic       csr_writeable;
    // CSR access logic.
    assign      invalid = !csr_exists || (!csr_writeable && we);
    
    // Output logic.
    assign mie      = csr_mstatus_mie ? csr_mie : 0;
    assign mtvec    = csr_mtvec;
    assign mepc_out = csr_mepc;
    
    
    
    /* ==== CSR ACCESS LOGIC ==== */
    always @(*) begin
        // CSR read and permission logic.
        case(addr)
            `RV_CSR_MSTATUS:    begin csr_exists = 1; csr_writeable = 1; dout = csr_mstatus; end
            `RV_CSR_MISA:       begin csr_exists = 1; csr_writeable = 1; dout = csr_misa; end
            `RV_CSR_MEDELEG:    begin csr_exists = 1; csr_writeable = 1; dout = csr_medeleg; end
            `RV_CSR_MIDELEG:    begin csr_exists = 1; csr_writeable = 1; dout = csr_mideleg; end
            `RV_CSR_MIE:        begin csr_exists = 1; csr_writeable = 1; dout = csr_mie; end
            `RV_CSR_MTVEC:      begin csr_exists = 1; csr_writeable = 1; dout = csr_mtvec; end
            `RV_CSR_MSTATUSH:   begin csr_exists = 1; csr_writeable = 1; dout = csr_mstatush; end
            `RV_CSR_MIP:        begin csr_exists = 1; csr_writeable = 1; dout = csr_mip; end
            `RV_CSR_MSCRATCH:   begin csr_exists = 1; csr_writeable = 1; dout = csr_mscratch; end
            `RV_CSR_MEPC:       begin csr_exists = 1; csr_writeable = 1; dout = csr_mepc; end
            `RV_CSR_MCAUSE:     begin csr_exists = 1; csr_writeable = 1; dout = csr_mcause; end
            `RV_CSR_MTVAL:      begin csr_exists = 1; csr_writeable = 1; dout = csr_mtval; end
            `RV_CSR_MVENDORID:  begin csr_exists = 1; csr_writeable = 0; dout = csr_mvendorid; end
            `RV_CSR_MARCHID:    begin csr_exists = 1; csr_writeable = 0; dout = csr_marchid; end
            `RV_CSR_MIPID:      begin csr_exists = 1; csr_writeable = 0; dout = csr_mipid; end
            `RV_CSR_MHARTID:    begin csr_exists = 1; csr_writeable = 0; dout = csr_mhartid; end
            `RV_CSR_MCONFIGPTR: begin csr_exists = 1; csr_writeable = 0; dout = csr_mconfigptr; end
            default:            begin csr_exists = 0; csr_writeable = 0; dout = 'bx; end
        endcase
    end
    
    always @(posedge clk) begin
        if (rst) begin
            // Rset CSRs to default values.
            csr_mstatus_mpie    <= 0;
            csr_mstatus_mie     <= 0;
            csr_mcause_int      <= 0;
            csr_mcause_no       <= 0;
            csr_mie             <= 0;
            csr_mtvec           <= 0;
            csr_mscratch        <= 0;
            csr_mepc            <= 0;
            
        end else if (trap) begin
            // CSR changes on trap or interrupt.
            csr_mstatus_mpie    <= 1;
            csr_mstatus_mie     <= 0;
            csr_mepc            <= mepc_in;
            csr_mcause_int      <= is_int;
            csr_mcause_no       <= cause;
            
        end else if (we) begin
            // CSR write logic.
            case (addr)
                default:            /* No action required. */;
                `RV_CSR_MSTATUS:    begin csr_mstatus_mpie <= din[7]; csr_mstatus_mie <= din[3]; end
                `RV_CSR_MIE:        begin csr_mie <= din; end
                `RV_CSR_MTVEC:      begin csr_mtvec <= din; end
                `RV_CSR_MSCRATCH:   begin csr_mscratch <= din; end
                `RV_CSR_MEPC:       begin csr_mepc <= din; end
                `RV_CSR_MCAUSE:     begin csr_mcause_int <= din[31]; csr_mcause_no <= din[4:0]; end
            endcase
        end
    end
endmodule
