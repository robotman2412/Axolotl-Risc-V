
    .global _start
_start:
    li a0, 32767
    li a1, 1
    sw a1, 0(a0)

halt:
    j halt

#     li a0, 32767
#     li a1, 1
    
# .loop:
#     sb a1, 0(a0)
#     jal wait
#     xori a1, a1, 1
    
#     j .loop
    
# wait:
#     li t0, 1000
# .waitloop:
#     addi t0, t0, -1
#     bnez t0, .waitloop
#     ret
