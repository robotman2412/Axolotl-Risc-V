
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`include "axo_defines.sv"

module axo32_alu_rv32im(
    // Left-hand side operand.
    input  wire[31:0] lhs,
    // Right-hand side operand
    input  wire[31:0] rhs,
    // Calculation/comparison result.
    output reg [31:0] res,
    
    // Instruction word.
    input  wire[31:0] insn
);
    `include "axo_functions.sv"
    
    // Signed edition.
    wire signed[31:0] slhs = lhs;
    wire signed[31:0] srhs = rhs;
    
    // Multiply resule.
    reg[63:0] mulres;
    
    always @(*) begin
        if (axo_inst_is_alu(insn) && insn[25]) begin
            // MULDIV ops.
            case (axo_inst_funct3(insn))
                `RV_MULDIV_MUL:     mulres = lhs  * rhs;
                `RV_MULDIV_MULH:    mulres = lhs  * rhs;
                `RV_MULDIV_MULHSU:  mulres = slhs * rhs;
                `RV_MULDIV_MULHU:   mulres = lhs  * rhs;
                `RV_MULDIV_DIV:     mulres = slhs / srhs;
                `RV_MULDIV_DIVU:    mulres = lhs  / rhs;
                `RV_MULDIV_REM:     mulres = slhs % srhs;
                `RV_MULDIV_REMU:    mulres = lhs  % rhs;
            endcase
            case (axo_inst_funct3(insn))
                `RV_MULDIV_MUL:     res = mulres[31:0];
                `RV_MULDIV_MULH:    res = mulres[63:32];
                `RV_MULDIV_MULHSU:  res = mulres[63:32];
                `RV_MULDIV_MULHU:   res = mulres[63:32];
                `RV_MULDIV_DIV:     res = mulres[31:0];
                `RV_MULDIV_DIVU:    res = mulres[31:0];
                `RV_MULDIV_REM:     res = mulres[31:0];
                `RV_MULDIV_REMU:    res = mulres[31:0];
            endcase
        end else if (axo_inst_is_alu(insn)) begin
            // Regular ALU ops.
            case (axo_inst_funct3(insn))
                `RV_ALU_ADD:    res = axo_inst_is_alu_imm(insn) && axo_inst_sub(insn) ? (lhs - rhs) : (lhs + rhs);
                `RV_ALU_SLL:    res = lhs << (rhs & 31);
                `RV_ALU_SLT:    res = slhs < srhs;
                `RV_ALU_SLTU:   res = lhs < rhs;
                `RV_ALU_XOR:    res = lhs ^ rhs;
                `RV_ALU_SRL:    res = axo_inst_sra(insn) ? slhs >> (rhs & 31) : lhs >> (rhs & 31);
                `RV_ALU_OR:     res = lhs | rhs;
                `RV_ALU_AND:    res = lhs & rhs;
            endcase
        end else if (axo_inst_opcode(insn) == `RV_OP_BRANCH) begin
            // Branches.
            if (insn[14] == 0) begin
                // BEQ, BNE.
                res = insn[12] ^ (lhs == rhs);
            end else if (insn[14:13] == 2'b10) begin
                // BLT, BGE.
                res = insn[12] ^ (slhs < srhs);
            end else begin
                // BLTU, BGEU.
                res = insn[12] ^ (lhs < rhs);
            end
        end else begin
            // Default is just an adder.
            res = lhs + rhs;
        end
    end
endmodule