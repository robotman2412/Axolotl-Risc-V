
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

`timescale 1ns/1ns
`include "axo_defines.sv"

module axo32_alu_rv32im(
    // Instruction word.
    input  wire[31:0] insn,
    // Left-hand side operand.
    input  wire[31:0] lhs,
    // Right-hand side operand
    input  wire[31:0] rhs,
    
    // Calculation/comparison result.
    output reg [31:0] res,
    // Adder output.
    output wire[31:0] add_res
);
    `include "axo_functions.sv"
    
    // Signed edition.
    wire signed[31:0] slhs = lhs;
    wire signed[31:0] srhs = rhs;
    
    // Multiplier output.
    reg [63:0] mulres;
    // Divider output.
    reg [31:0] divres;
    // Adder output.
    wire[32:0] addres;
    assign     add_res = addres;
    // Logic output.
    reg [31:0] logicres;
    
    // Output multiplexer.
    always @(*) begin
        if (axo_insn_opcode(insn) == `RV_OP_OP && insn[25]) begin
            // MULDIV ops.
            res = insn[14] ? divres : insn[13:12] != 0 ? mulres[63:32] : mulres[31:0];
        end else if (axo_insn_is_alu(insn) && axo_insn_funct3(insn) != 0) begin
            // Logic ops.
            res = logicres;
        end else if (axo_insn_opcode(insn) == `RV_OP_BRANCH) begin
            // Branch ops.
            res = logicres;
        end else begin
            // Add ops.
            res = addres[31:0];
        end
    end
    
    // Multiplier.
    always @(*) begin
        case (axo_insn_funct3(insn))
            default:            mulres = slhs * srhs;
            `RV_MULDIV_MULHU:   mulres = lhs  * rhs;
            `RV_MULDIV_MULHSU:  mulres = slhs * rhs;
        endcase
    end
    
    // Divider.
    always @(*) begin
        case (axo_insn_funct3(insn))
            default:            divres = slhs / srhs;
            `RV_MULDIV_DIVU:    divres = lhs  / rhs;
            `RV_MULDIV_REM:     divres = slhs % srhs;
            `RV_MULDIV_REMU:    divres = lhs  % rhs;
        endcase
    end
    
    // Adder.
    reg add_xor_msb;
    reg add_xor;
    wire[31:0] add_a  = lhs ^ (add_xor_msb * 32'h8000_0000);
    wire[31:0] add_b  = rhs ^ (add_xor_msb * 32'h8000_0000) ^ (add_xor * 32'hffff_ffff);
    assign     addres = (add_a + add_b) ^ (add_xor * 33'hffff_ffff);
    always @(*) begin
        if (axo_insn_opcode(insn) == `RV_OP_BRANCH) begin
            // Branch comparison.
            add_xor_msb = !insn[13];
            add_xor     = 1;
        end else if (axo_insn_is_alu(insn) && axo_insn_funct3(insn) != 0) begin
            // Set comparison.
            add_xor_msb = !insn[12];
            add_xor     = 1;
        end else if (axo_insn_opcode(insn) == `RV_OP_OP && insn[30]) begin
            // Subtract register.
            add_xor_msb = 0;
            add_xor     = 1;
        end else begin
            // Normal addition.
            add_xor_msb = 0;
            add_xor     = 0;
        end
    end
    
    // Logic.
    wire eq_res = addres[31:0] == 0;
    wire lt_res = addres[31:0] != 0 && !addres[32];
    always @(*) begin
        if (axo_insn_opcode(insn) == `RV_OP_BRANCH) begin
            // Branch instructions.
            case (axo_insn_funct3(insn))
                default:        logicres = 'bx;
                `RV_BRANCH_BEQ: logicres = eq_res;
                `RV_BRANCH_BNE: logicres = !eq_res;
                `RV_BRANCH_BLT: logicres = lt_res;
                `RV_BRANCH_BGE: logicres = !lt_res;
                `RV_BRANCH_BLTU:logicres = lt_res;
                `RV_BRANCH_BGEU:logicres = !lt_res;
            endcase
        end else begin
            // Logic instructions.
            case (axo_insn_funct3(insn))
                default:        logicres = lhs << (rhs & 31);
                `RV_ALU_SLT:    logicres = lt_res;
                `RV_ALU_SLTU:   logicres = lt_res;
                `RV_ALU_XOR:    logicres = lhs ^ rhs;
                `RV_ALU_SRL:    logicres = axo_insn_sra(insn) ? slhs >> (rhs & 31) : lhs >> (rhs & 31);
                `RV_ALU_OR:     logicres = lhs | rhs;
                `RV_ALU_AND:    logicres = lhs & rhs;
            endcase
        end
    end
endmodule



/*
    // Signed edition.
    wire signed[31:0] slhs = lhs;
    wire signed[31:0] srhs = rhs;
    
    // Multiply result.
    reg[63:0] mulres;
    
    always @(*) begin
        if (axo_insn_opcode(insn) == `RV_OP_OP && insn[25]) begin
            // MULDIV ops.
            case (axo_insn_funct3(insn))
                `RV_MULDIV_MUL:     mulres = lhs  * rhs;
                `RV_MULDIV_MULH:    mulres = slhs * srhs;
                `RV_MULDIV_MULHSU:  mulres = slhs * rhs;
                `RV_MULDIV_MULHU:   mulres = lhs  * rhs;
                `RV_MULDIV_DIV:     mulres = slhs / srhs;
                `RV_MULDIV_DIVU:    mulres = lhs  / rhs;
                `RV_MULDIV_REM:     mulres = slhs % srhs;
                `RV_MULDIV_REMU:    mulres = lhs  % rhs;
            endcase
            case (axo_insn_funct3(insn))
                `RV_MULDIV_MUL:     res = mulres[31:0];
                `RV_MULDIV_MULH:    res = mulres[63:32];
                `RV_MULDIV_MULHSU:  res = mulres[63:32];
                `RV_MULDIV_MULHU:   res = mulres[63:32];
                `RV_MULDIV_DIV:     res = mulres[31:0];
                `RV_MULDIV_DIVU:    res = mulres[31:0];
                `RV_MULDIV_REM:     res = mulres[31:0];
                `RV_MULDIV_REMU:    res = mulres[31:0];
            endcase
        end else if (axo_insn_is_alu(insn)) begin
            // Regular ALU ops.
            case (axo_insn_funct3(insn))
                `RV_ALU_ADD:    res = !axo_insn_is_alu_imm(insn) && axo_insn_sub(insn) ? (lhs - rhs) : (lhs + rhs);
                `RV_ALU_SLL:    res = lhs << (rhs & 31);
                `RV_ALU_SLT:    res = slhs < srhs;
                `RV_ALU_SLTU:   res = lhs < rhs;
                `RV_ALU_XOR:    res = lhs ^ rhs;
                `RV_ALU_SRL:    res = axo_insn_sra(insn) ? slhs >> (rhs & 31) : lhs >> (rhs & 31);
                `RV_ALU_OR:     res = lhs | rhs;
                `RV_ALU_AND:    res = lhs & rhs;
            endcase
        end else if (axo_insn_opcode(insn) == `RV_OP_BRANCH) begin
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
*/
