
# Architecture summary

This document describes a summary of how I will design the CPU core.

Axolotl³² implements RV32 from the Risc-V specification:
- [Specifications page](https://riscv.org/technical/specifications/)
- [Document link](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf)

I may play around with non-standard extensions later, but this will start as strictly RV32I.



# Terms

## RV32*

RV32 is the prefix specified for 32-bit Risc-V processors.
This is RV64 for 64-bit Risc-V processors.

After the prefix comes a set of extensions,
I will only talk about the relevant ones here.
| Letter | Purpose
| :----- | :------
| `I`    | Base integer instruction set, all processors implement this.
| `M`    | Extension: Multiplication and division instructions.
| `A`    | Extension: Atomic instructions (used for multi-threading).
| `C`    | Extension: Compressed instructions (which can be 16-bit instead of the usual 32)
| `F`    | Extension: Single-precision floating-point (IEEE754 binary32).
| `D`    | Extension: Double-precision floating-point (IEEE754 binary64; superset of `F`).

This processor shall implement initially `RV32I` and the goal is `RV32IMC`.
A stretch goal is `RV32IMACD`, to support the ABI requested by C and C++ libraries.

## XLEN

XLEN descibes the word size of the processor.
The word size definition used here is the register size,
in addition to being the largest size that math can be performed on in one instruction.



# Registers

RV32I has 32 registers in addition to the program counter:
 - `x0` (also named `zero`)
   - Always holds the constant value 0
   - Physical index 0
 - `x1` through `x31`
   - Main register file
   - 32-bit storage
   - Physical indices 1 through 31
 - `pc` (program counter)
   - Address to next instruction to run



# Instruction set summary

This is a summary of all instructions in the RV32I instruction set.
 - *Type* refers to the encoding type of the instructions (`R`, `I`, `S` or `U`).
 - *Assembly* refers to the assembly code associated.
 - *Purpose* describes what instructions do (mostly in terms of C-style expressions).

## Register-Immediate computational
| Type | Assembly               | Purpose
| :--- | :--------------------- | :------
| `I`  | `ADDI  rd, rs1, imm`   | `rd` = `rs1` + `imm`
| `I`  | `SLTI  rd, rs1, imm`   | `rd` = `rs1` < `imm` (signed context)
| `I`  | `SLTIU rd, rs1, imm`   | `rd` = `rs1` < `imm` (unsigned context)
| `I`  | `ANDI  rd, rs1, imm`   | `rd` = `rs1` & `imm`
| `I`  | `ORI   rd, rs1, imm`   | `rd` = `rs1` \| `imm`
| `I`  | `XORI  rd, rs1, imm`   | `rd` = `rs1` ^ `imm`
| `I`  | `SLLI  rd, rs1, imm`   | `rd` = `rs1` << `imm` (logical; lower 5 bits of `imm` in encoding)
| `I`  | `SRLI  rd, rs1, imm`   | `rd` = `rs1` >> `imm` (logical; lower 5 bits of `imm` in encoding)
| `I`  | `SRAI  rd, rs1, imm`   | `rd` = `rs1` >> `imm` (arithmetic; lower 5 bits of `imm` in encoding)
| `U`  | `LUI   rd, imm`        | `rd` = `imm` (where `imm` is the upper 20 bits, lower 12 are zero)

## Register-Register computational
| Type | Assembly               | Purpose
| :--- | :--------------------- | :------
| `R`  | `ADD   rd, rs1, rs2`   | `rd` = `rs1` + `rs2`
| `R`  | `SLT   rd, rs1, rs2`   | `rd` = `rs1` < `rs2` (signed context)
| `R`  | `SLTU  rd, rs1, rs2`   | `rd` = `rs1` < `rs2` (unsigned context)
| `R`  | `AND   rd, rs1, rs2`   | `rd` = `rs1` & `rs2`
| `R`  | `OR    rd, rs1, rs2`   | `rd` = `rs1` \| `rs2`
| `R`  | `XOR   rd, rs1, rs2`   | `rd` = `rs1` ^ `rs2`
| `R`  | `SLL   rd, rs1, rs2`   | `rd` = `rs1` << (`rs2` & 31) (logical)
| `R`  | `SRL   rd, rs1, rs2`   | `rd` = `rs1` >> (`rs2` & 31) (logical)
| `R`  | `SUB   rd, rs1, rs2`   | `rd` = `rs1` - `rs2`
| `R`  | `SRA   rd, rs1, rs2`   | `rd` = `rs1` >> (`rs2` & 31) (arithmetic)

## Control transfer
| Type | Assembly               | Purpose
| :--- | :--------------------- | :------
| `U`  | `JAL   rd, addr`       | Store PC to `rd`, then jump to `addr`
| `I`  | `JALR  rd, off(rs1)`   | Store PC to `rd`, then jump to address `rs1`+`off`
| `S`  | `BEQ   rs1, rs2, addr` | Branch to `addr` if `rs1` == `rs2`
| `S`  | `BNE   rs1, rs2, addr` | Branch to `addr` if `rs1` != `rs2`
| `S`  | `BLT   rs1, rs2, addr` | Branch to `addr` if `rs1` < `rs2` (`BGT` can be formed by swapping `rs1` and `rs2`)
| `S`  | `BGE   rs1, rs2, addr` | Branch to `addr` if `rs1` >= `rs2` (`BLE` can be formed by swapping `rs1` and `rs2`)

## Memory access
| Type | Assembly               | Purpose
| :--- | :--------------------- | :------
| `I`  | `L*    rd, addr(rs1)`  | Load memory at `addr` + `rs1` into `rd`
| `S`  | `S*    rs1, addr(rs2)` | Store `rs1` into memory at `addr` + `rs2`
| `I`  | `FENCE`                | Memory ordering command

## Environment calls
| Type | Assembly               | Purpose
| :--- | :--------------------- | :------
| `I`  | `ECALL`                | System call
| `I`  | `EBREAK`               | Debug break



# Opcode values
As encoded in bits[6:2] in the 32-bit instruction.
If bits[1:0] != 11 then the instruction is a 16-bit compressed instruction.

| Binary | Hex | Name      | Type | Purpose
| :----- | :-- | :-------- | :--- | :------
| 00000  | 00  | LOAD      | I    | Load from memory.
| 00001  | 01  | LOAD-FP   |      | Load into FPU?
| 00010  | 02  | custom-0  |      | For use with custom extensions.
| 00011  | 03  | MISC-MEM  | I    | Other memory operations (e.g. fence).
| 00100  | 04  | OP-IMM    | I    | XLEN-bit Register-Immediate computation.
| 00101  | 05  | AUIPC     | U    | Add upper immediate to PC.
| 00110  | 06  | OP-IMM-32 |      | 32-bit Register-Immediate computation.
| 00111  | 07  |           |      | 48-bit instructions.
| 01000  | 08  | STORE     | S    | Store to memory.
| 01001  | 09  | STORE-FP  |      | Store from FPU?
| 01010  | 0A  | custom-1  |      | For use with custom extensions.
| 01011  | 0B  | AMO       |      | Alternate memory ordering.
| 01100  | 0C  | OP        | R    | XLEN-bit Register-Register computation.
| 01101  | 0D  | LUI       | U    | Load upper immediate.
| 01110  | 0E  | OP-32     |      | 32-bit Register-Register computation.
| 01111  | 0F  |           |      | 64-bit instructions.
| 10000  | 10  | MADD      |      | Multiply and add.
| 10001  | 11  | MSUB      |      | Multiply and subtract.
| 10010  | 12  | NMSUB     |      | Negate, multiply and subtract.
| 10011  | 13  | NMADD     |      | Negate, multiply and add.
| 10100  | 14  | OP-FP     |      | Floating-point operation.
| 10101  | 15  |           |      | Reserved.
| 10110  | 16  |           |      | RV32/RV64: For use with custom extensions. RV64: Reserved.
| 10111  | 17  |           |      | 56-bit instructions.
| 11000  | 18  | BRANCH    | B    | Conditional branch.
| 11001  | 19  | JALR      | I    | Unconditional jump and link from register.
| 11010  | 1A  |           |      | Reserved.
| 11011  | 1B  | JAL       | J    | Unconditional jump and link.
| 11100  | 1C  | SYSTEM    |      | System calls.
| 11101  | 1D  |           |      | Reserved.
| 11110  | 1E  |           |      | RV32/RV64: For use with custom extensions. RV64: Reserved.
| 11111  | 1F  |           |      | Very long (>= 80 bit) instructions.
