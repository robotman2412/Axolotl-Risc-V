
    .global _start
_start:
    la t0, isr
    csrw mtvec, t0
    csrr t1, mtvec
    li s0, 1
    .word 0xffffffff
    li s0, 2

halt:
    j halt

isr:
    li s0, 3
    la t0, retour
    csrw mepc, t0
    mret
    j halt

retour:
    li s0, 4
    j halt
    
    nop
