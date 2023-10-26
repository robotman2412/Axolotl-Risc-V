
    .global _start
_start:
    la t0, isr
    csrw mtvec, t0
    csrsi mtvec, 8
    
    li a0, 0xcafebabe
    lw s0, 0(a0)

halt:
    j halt

isr:
    li s0, 0xdeadbeef
    j halt
    
    nop
