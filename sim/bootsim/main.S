
    .global _start
_start:
    la t0, isr
    csrw mtvec, t0
    csrsi mtvec, 8
    
    li a0, 0xcafebabe
    
    li t0, 'H'
    sw t0, 256(x0)
    li t0, 'e'
    sw t0, 256(x0)
    li t0, 'l'
    sw t0, 256(x0)
    li t0, 'l'
    sw t0, 256(x0)
    li t0, 'o'
    sw t0, 256(x0)
    li t0, ','
    sw t0, 256(x0)
    li t0, ' '
    sw t0, 256(x0)
    li t0, 'W'
    sw t0, 256(x0)
    li t0, 'o'
    sw t0, 256(x0)
    li t0, 'r'
    sw t0, 256(x0)
    li t0, 'l'
    sw t0, 256(x0)
    li t0, 'd'
    sw t0, 256(x0)
    li t0, '!'
    sw t0, 256(x0)
    
    li a0, 0xf00dbabe

halt:
    j halt

isr:
    li s0, 0xdeadbeef
    j halt
    
    nop
