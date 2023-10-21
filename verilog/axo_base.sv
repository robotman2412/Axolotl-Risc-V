
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
    
    // Write data.
    input  wire[XLEN-1:0] din,
    // Read data 1.
    output wire[XLEN-1:0] dout1,
    // Read data 2.
    output wire[XLEN-1:0] dout2
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



// Immediate operand decoder.
module axo_decd_imm#(
    // XLEN; amount of bits to expand output IMM to.
    parameter XLEN = 32
)(
    // Input instruction to analyse.
    input  wire[31:0] inst,
    // Embedded immediate value, if any.
    output wire[XLEN-1:0] imm
);
    reg is_r_type, is_b_type, is_i_type, is_j_type, is_s_type, is_u_type;
    
    // IMM format decoder.
    always @(*) begin
        is_r_type = 0;
        is_b_type = 0;
        is_i_type = 0;
        is_j_type = 0;
        is_s_type = 0;
        is_u_type = 0;
        
        if (inst[1:0] == 'b11)
        case(inst[6:2])
            `RV_OP_LOAD:        is_i_type = 1;
            `RV_OP_LOAD_FP:     is_i_type = 1;
            `RV_OP_MISC_MEM:    is_i_type = 1;
            `RV_OP_OP_IMM:      is_i_type = 1;
            `RV_OP_AUIPC:       is_u_type = 1;
            `RV_OP_OP_IMM_32:   is_i_type = 1;
            `RV_OP_STORE:       is_s_type = 1;
            `RV_OP_STORE_FP:    is_s_type = 1;
            `RV_OP_AMO:         ; // Other
            `RV_OP_OP:          is_r_type = 1;
            `RV_OP_LUI:         is_u_type = 1;
            `RV_OP_OP_32:       is_r_type = 1;
            `RV_OP_MADD:        ; // Other
            `RV_OP_MSUB:        ; // Other
            `RV_OP_NMSUB:       ; // Other
            `RV_OP_NMADD:       ; // Other
            `RV_OP_OP_FP:       ; // Other
            `RV_OP_BRANCH:      is_b_type = 1;
            `RV_OP_JALR:        is_i_type = 1;
            `RV_OP_JAL:         is_j_type = 1;
            `RV_OP_SYSTEM:      ; // TODO
            default: ; // Illegal
        endcase
    end
    
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
                is_j_type ? inst[19:12] : inst[31] * 'hff;
    
    // Bits 20-30.
    assign imm[30:20] =
                is_u_type ? inst[30:20] : inst[31] * 'h7ff;
    
    // Bits 31 and up.
    genvar i;
    generate
        for (i = 31; i < XLEN; i = i + 1) begin
            assign imm[i] = inst[31];
        end
    endgenerate
endmodule



// CSR write value helper.
module axo_csr_helper#(
    // XLEN; amount of bits stored in CSRs.
    parameter XLEN = 32
)(
    // CSR old value.
    input  wire[XLEN-1:0] old,
    // IMM or register value.
    input  wire[XLEN-1:0]  bitmask,
    // FUNCT3 from SYSTEM opcode.
    input  wire[2:0]      FUNCT3,
    // CSR write enable.
    input  wire           write,
    // CSR new value.
    output reg [XLEN-1:0] new
);
    always @(*) begin
        if (write) begin
            case (FUNCT3)
                `RV_SYSTEM_CSRRC:  new = old & ~bitmask;
                `RV_SYSTEM_CSRRCI: new = old & ~bitmask;
                `RV_SYSTEM_CSRRS:  new = old | bitmask;
                `RV_SYSTEM_CSRRSI: new = old | bitmask;
                `RV_SYSTEM_CSRRW:  new = bitmask;
                `RV_SYSTEM_CSRRWI: new = bitmask;
                default: new = old;
            endcase
        end else begin
            new = old;
        end
    end
endmodule
