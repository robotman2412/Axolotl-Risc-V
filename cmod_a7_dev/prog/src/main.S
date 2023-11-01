
    .global _start
_start:
    la a0, isr
    csrw mtvec, a0
    li a0, 0x00010000
    csrw mie, a0
    
    li a0, 'H'
    sw a0, 256(x0)
    li a0, 'i'
    sw a0, 256(x0)
    li a0, ' '
    sw a0, 256(x0)
    li a0, 'T'
    sw a0, 256(x0)
    li a0, 'h'
    sw a0, 256(x0)
    li a0, 'e'
    sw a0, 256(x0)
    li a0, 'r'
    sw a0, 256(x0)
    li a0, '.'
    sw a0, 256(x0)
    li a0, '\r'
    sw a0, 256(x0)
    li a0, '\n'
    sw a0, 256(x0)
    
    csrsi mstatus, 8
loop:
    j loop

isr:
    lw a0, 256(x0)
    sw a0, 256(x0)
    mret
