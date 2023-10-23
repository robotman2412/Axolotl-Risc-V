
    .global _start
_start:
    li s0, 0
    li s1, 0
    li s2, 1
.loop:
    mv s0, s1
    mv s1, s2
    add s2, s0, s1
    mv a0, s0
    jal putd
    j .loop


putd:
    li a5, 10
    li a2, 0
.divloop:
    // Eat the lowest digit.
    remu a1, a0, a5
    divu a0, a0, a5
    // Convert into ASCII.
    ori a1, a1, '0'
    // Store in buffer.
    sb a1, 32(a2)
    addi a2, a2, 1
    // Check if there are remaining digits.
    bne a0, x0, .divloop
    
.printloop:
    // Grab first digit.
    addi a2, a2, -1
    lb a1, 32(a2)
    // Print it.
    sw a1, 255(x0)
    // Check if there are remaining digits.
    bne a2, x0, .printloop
    
    // Print newline.
    li a0, '\n'
    sw a0, 255(x0)
    ret
    
    nop
    nop
    nop
