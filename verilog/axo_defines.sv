
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

// RISC-V opcodes.
`define RV_OP_LOAD      'b00000
`define RV_OP_LOAD_FP   'b00001
`define RV_OP_custom_0  'b00010
`define RV_OP_MISC_MEM  'b00011
`define RV_OP_OP_IMM    'b00100
`define RV_OP_AUIPC     'b00101
`define RV_OP_OP_IMM_32 'b00110
`define RV_OP_STORE     'b01000
`define RV_OP_STORE_FP  'b01001
`define RV_OP_custom_1  'b01010
`define RV_OP_AMO       'b01011
`define RV_OP_OP        'b01100
`define RV_OP_LUI       'b01101
`define RV_OP_OP_32     'b01110
`define RV_OP_MADD      'b10000
`define RV_OP_MSUB      'b10001
`define RV_OP_NMSUB     'b10010
`define RV_OP_NMADD     'b10011
`define RV_OP_OP_FP     'b10100
`define RV_OP_custom_2  'b10110
`define RV_OP_BRANCH    'b11000
`define RV_OP_JALR      'b11001
`define RV_OP_JAL       'b11011
`define RV_OP_SYSTEM    'b11100
`define RV_OP_custom_3  'b11110

// RISC-V branch FUNCT3 values.
`define RV_BRANCH_BEQ   'b000
`define RV_BRANCH_BNE   'b001
`define RV_BRANCH_BLT   'b100
`define RV_BRANCH_BGE   'b101
`define RV_BRANCH_BLTU  'b110
`define RV_BRANCH_BGEU  'b111

// RISC-V ALU FUNCT3 values.
`define RV_ALU_ADD      'b000
`define RV_ALU_SLL      'b001
`define RV_ALU_SLT      'b010
`define RV_ALU_SLTU     'b011
`define RV_ALU_XOR      'b100
`define RV_ALU_SRL      'b101
`define RV_ALU_OR       'b110
`define RV_ALU_AND      'b111

// RISC-V MULDIV FUNCT3 values.
`define RV_MULDIV_MUL       'b000
`define RV_MULDIV_MULH      'b001
`define RV_MULDIV_MULHSU    'b010
`define RV_MULDIV_MULHU     'b011
`define RV_MULDIV_DIV       'b100
`define RV_MULDIV_DIVU      'b101
`define RV_MULDIV_REM       'b110
`define RV_MULDIV_REMU      'b111

// RISC-V SYSTEM FUNCT3 values.
`define RV_SYSTEM_ECALL  'b000
`define RV_SYSTEM_CSRRW  'b001
`define RV_SYSTEM_CSRRS  'b010
`define RV_SYSTEM_CSRRC  'b011
`define RV_SYSTEM_CSRRWI 'b101
`define RV_SYSTEM_CSRRSI 'b110
`define RV_SYSTEM_CSRRCI 'b111
