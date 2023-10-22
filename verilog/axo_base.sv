
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



module axo_reg_decoder#(
    // Check for atomic instructions.
    parameter a = 0,
    // Check for float instructions.
    parameter f = 0,
    // Check for RV64 instructions.
    parameter rv64 = 0
)(
    input  wire[31:0] insn,
    output reg        has_rs1,
    output reg        has_rs2,
    output reg        has_rs3,
    output reg        has_rd
);
    `include "axo_functions.sv"
    
    always @(*) begin
        has_rs1 <= 'bx; has_rs2 <= 'bx; has_rs3 <= 'bx; has_rd <= 'bx;
        case (axo_insn_opcode(insn))
            `RV_OP_LOAD:        begin has_rs1 <= 1; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_LOAD_FP:     if (f) begin has_rs1 <= 1; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_MISC_MEM:    begin has_rs1 <= 0; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 0; end
            `RV_OP_OP_IMM:      begin has_rs1 <= 1; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_AUIPC:       begin has_rs1 <= 0; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_OP_IMM_32:   if (rv64) begin has_rs1 <= 1; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_STORE:       begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 0; end
            `RV_OP_STORE_FP:    if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 0; end
            `RV_OP_AMO:         if (a) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_OP:          begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_LUI:         begin has_rs1 <= 0; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_OP_32:       if (rv64) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_MADD:        if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 1; has_rd <= 1; end
            `RV_OP_MSUB:        if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 1; has_rd <= 1; end
            `RV_OP_NMSUB:       if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 1; has_rd <= 1; end
            `RV_OP_NMADD:       if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 1; has_rd <= 1; end
            `RV_OP_OP_FP:       if (f) begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_BRANCH:      begin has_rs1 <= 1; has_rs2 <= 1; has_rs3 <= 0; has_rd <= 0; end
            `RV_OP_JALR:        begin has_rs1 <= 1; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_JAL:         begin has_rs1 <= 0; has_rs2 <= 0; has_rs3 <= 0; has_rd <= 1; end
            `RV_OP_SYSTEM:
                begin
                    if (insn[14:12] != 0) begin
                        has_rs1 <= !insn[14]; has_rs2 <= 0; has_rd <= 1;
                    end else begin
                        has_rs1 <= 0; has_rs2 <= 0; has_rd <= 0;
                    end
                end
        endcase
    end
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
