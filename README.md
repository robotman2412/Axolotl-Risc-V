
# Axolotl³²: An implementation of RV32
Axolotl³² is my first implementation of an ISA not of my own design.
The main reason for this project is that I want to have a C compiler for my CPU projects,
and Risc-V is an open-source royalty-free architecture with existing open-source compilers.

Also, I'm like, totally going to make a simple RTOS for it.

# Specifications

Axolotl³² implements RV32 from the Risc-V specification:
- [Specifications page](https://riscv.org/technical/specifications/)
- [Document link](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf)

I may play around with non-standard extensions later, but this will start as strictly RV32I.
