
    .global _start
_start:
    li a0, 0
    li a1, 9
    bne x0, a1, l1
    
l2:
    j l3
    li a0, 1
    
l1:
    beq x0, x0, l2
    li a0, 2

l3:
    bne x0, a1, l4
    li a0, 3
    
l4:
    j l5
    li a0, 4
    
l5:
    li a0, 0xdeadbeef
l6:
    j l6
    li a0, 5
