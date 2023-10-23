
# Architecture summary

This document describes a summary of how I will design the CPU core.

Axolotl³² (or Axo32) /implements RV32IM from the [RISC-V specification](https://riscv.org/technical/specifications/).

## Index
- [Design goals](#design-goals)
- [Features](#features)
- [Architecture overview](#architecture-overview)
- [IF stage](#if-stage)
- [ID stage](#id-stage)
- [EX stage](#ex-stage)
- [Pipeline hazard avoidance](#id-stage)



# Design goals

The primary goal while designing Axo32 is for me to learn pipelined CPU architecture. This time, I chose to use the RISC-V ISA instead of making a custom instruction set because there are already C compilers and operating systems for RISC-V.

The secondary goal is continuing to evolve the performance of my CPUs. In the past, from GR8CPU, GR8CPUr2, GR8CPUr3 and PX16, I increased performance by wasting less time on loading and decoding instructions, which culminated in PX16's throughput of up to 0.5 IPC. This time, leveraging pipelined CPU architecture, Axo32 should theoretically reach a throughput of up to 1.0 IPC.

In addition, the pipelined design allows for higher clock speeds by reducing the length of the critical path, though I'll touch on the limits there later.



# Features

The first version of Axo32 will implement unprivileged RV32IM; the base 32-bit instruction set and multiply/divide extension. Later models of Axo32 will implement RV32IMAC; adding atomics and compressed instructions.

The minimum viable product will implement the RISC-V privileged specification; this will add privileged instructions and implement memory access permissions and protections. This would allow small OSes without memory mapping units to run on Axo32.

If I have enough spare time, this would evolve up to implementing supervisor mode and Sv32, the 34-bit page-based virtual memory extension, the both of which combined allow modern OSes like Linux to run.

## Proof of concept
| Feature                   | Implementation
| :------------------------ | :-------------
| Instruction set           | RV32IM
| Bits                      | 32
| Multiply                  | Yes
| Divide                    | Yes
| Atomics                   | No
| Compressed instructions   | No
| Privilege modes           | M
| Memory protection         | No
| Virtual memory            | No

## Minimum viable product
| Feature                   | Implementation
| :------------------------ | :-------------
| Instruction set           | RV32IM
| Bits                      | 32
| Multiply                  | Yes
| Divide                    | Yes
| Atomics                   | Yes
| Compressed instructions   | Yes
| Privilege modes           | M, U
| Memory protection         | Yes
| Virtual memory            | No

## Stretch goals
| Feature                   | Implementation
| :------------------------ | :-------------
| Instruction set           | RV32IM
| Bits                      | 32
| Multiply                  | Yes
| Divide                    | Yes
| Atomics                   | Yes
| Compressed instructions   | Yes
| Privilege modes           | M, S, U
| Memory protection         | Yes
| Virtual memory            | Yes; 34-bit



# Architecture overview

Axo32 is an in-order, 3-stage pipelined RISC-V CPU with simple branch prediction. The pipeline is organized as follows:
- IF: Instruction fetch
- ID: Instruction decode
- EX: Execution

The instruction fetch stage is responsible for loading instructions from memory and determining their length.
The IF stage will have a program counter, the program bus, an instruction length decoder, an adder that calculates the address of the next instruction and a register storing the path to take on a mispredicted branch.

The instruction decode stage determines the validity of, decodes instructions and calculates the target address of a jump or branch.
The ID stage will have a set of decoders for immediate values, memory address offsets, CSR numbers and register indices, and have an adder for calculating the branch target address.

The execution stage is responsible for doing integer computation, accessing memory or CSRs and providing a result to write back to the register file.
The EX stage will have a multi-purpose ALU, the data bus, the CSR regfile and an output multiplexer.

Axo32 will have a branch predictor to decrease latency on branch instructions.
The branch predictor is stateless; any forward branch is predicted untaken while any backward branch is predicted taken.

# IF stage

# ID stage

# EX stage

# Pipeline hazard avoidance

The branch prediction will be stateless and, in accordance with the RISC-V specification will:
- Predict all backward branches as taken
- Predict all forward branches as not taken
- Suffer a 1-cycle penalty on any taken jump or conditional branch
- Suffer no penalty on any untaken conditional branch
- Suffer a 2-cycle penalty on any mispredicted conditional branch (instead of the 0 to 1 cycle penalty)
