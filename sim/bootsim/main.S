
    .global _start
_start:
    // Set ISR vector.
    la t0, isr
    csrw mtvec, t0
    // Enable external interrupt.
    li t1, 0x00080000
    csrw mie, t1
    // Enable interrupts.
    li t2, 0x00000008
    csrw mstatus, t2
    // Put a canary in s0.
    li s0, 0xcafebabe

halt:
    // Spin in circles until an interrupt happens.
    j halt

isr:
    // Update s0.
    li s0, 0xdeadbeef
    // Disable the external interrupt.
    li t1, 0x00080000
    csrc mie, t1
    // Return from the interrupt handler.
    mret
    
    nop
