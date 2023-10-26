
    .global _start
_start:
    la a0, myconst
    lw a1, myconst
halt:
    j halt
    nop
    
myconst:
    .word 0xdeadbeef
    
    nop
