
    .global _start
_start:
    nop
    nop
    nop
    nop
    li a0, 1
    sw a0, 256(x0)

loop:
    lw a0, 260(x0)
    xori a0, a0, 1
    # srli a0, a0, 1
    # sw a0, 260(x0)
    j loop
