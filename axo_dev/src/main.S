
    .global _start
_start:
    la t0, isr
    csrw mtvec, t0
    
    li a0, 1
    sw a0, 256(x0)
    sw a0, 260(x0)

    li s0, 0xf00dbabe
halt:
    j halt

isr:
    li s0, 0xdeadbeef
    j halt
    
    nop
