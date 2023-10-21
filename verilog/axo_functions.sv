
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

// Get opcode from 32-bit instruction.
function automatic [4:0] axo_inst_opcode(input[31:0] insn);
    begin
        axo_inst_opcode = insn[6:2];
    end
endfunction

// Get FUNCT3 from 32-bit instruction.
function automatic [2:0] axo_inst_funct3(input[31:0] insn);
    begin
        axo_inst_funct3 = insn[14:12];
    end
endfunction

// Get RS1 from 32-bit instruction.
function automatic [4:0] axo_inst_rs1(input[31:0] insn);
    begin
        axo_inst_rs1 = insn[19:15];
    end
endfunction

// Get RS2 from 32-bit instruction.
function automatic [4:0] axo_inst_rs2(input[31:0] insn);
    begin
        axo_inst_rs2 = insn[24:20];
    end
endfunction

// Get RD from 32-bit instruction.
function automatic [4:0] axo_inst_rd(input[31:0] insn);
    begin
        axo_inst_rd = insn[11:7];
    end
endfunction

// Get shift amount from 32-bit instruction.
function automatic [5:0] axo_inst_shamt(input[31:0] insn);
    begin
        axo_inst_shamt = insn[25:20];
    end
endfunction

// Get shift is arithmetic from 32-bit instruction.
function automatic [0:0] axo_inst_sra(input[31:0] insn);
    begin
        axo_inst_sra = insn[30];
    end
endfunction

// Get subtract mode from 32-bit instruction.
function automatic [0:0] axo_inst_sub(input[31:0] insn);
    begin
        axo_inst_sub = insn[30];
    end
endfunction

// Is it one of the OP* opcodes?
function automatic [0:0] axo_inst_is_alu(input[31:0] insn);
    begin
        axo_inst_is_alu = !insn[6] && insn[4] && !insn[2];
    end
endfunction

// Assuming the opcode is one of the OP* opcodes, is the opcode OP-32 or OP-IMM-32?
function automatic [0:0] axo_inst_is_alu_32(input[31:0] insn);
    begin
        axo_inst_is_alu_32 = insn[3];
    end
endfunction

// Assuming the opcode is one of the OP* opcodes, is the opcode OP-IMM or OP-IMM-32?
function automatic [0:0] axo_inst_is_alu_imm(input[31:0] insn);
    begin
        axo_inst_is_alu_imm = !insn[5];
    end
endfunction

// Determine whether the instruction is 32 bits long.
function automatic [0:0] axo_inst_length(input[31:0] insn);
    begin
        axo_inst_length = insn[1:0] == 2'b11;
    end
endfunction
