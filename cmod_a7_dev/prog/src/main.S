
    .equ uart0_base,    4096
    .equ uart_fifo,     0
    .equ uart_status,   4

    .global _start
_start:
    li sp, 4096
    
    la a0, isr
    csrw mtvec, a0
    li a0, 0x00010000
    csrw mie, a0
    
    li a0, 0xdeadbeef
    jal putx
halt:
    j halt
    
    li t0, 512
    li a0, 0
    sw a0, 0(t0)
    sw a0, 4(t0)
    sw a0, 8(t0)
    sw a0, 12(t0)
    
    li a0, 0xcafebabe
    sw a0, 1(t0)
    li a0, 0xbaadf00d
    sh a0, 6(t0)
    li a0, 0x12345678
    sb a0, 11(t0)
    
    lw a0, 0(t0)
    jal putx
    lw a0, 4(t0)
    jal putx
    lw a0, 8(t0)
    jal putx
    lw a0, 12(t0)
    jal putx
    li a0, '\r'
    li t0, uart0_base
    sw a0, uart_fifo(t0)
    li a0, '\n'
    sw a0, uart_fifo(t0)
    
    csrsi mstatus, 8
loop:
    j loop


putx:
    addi sp, sp, -16
    sw ra, 16(sp)
    li a2, 9
    li t0, uart0_base
    
    srli a1, a0, 28
    jal putx_d
    srli a1, a0, 24
    andi a1, a1, 15
    jal putx_d
    srli a1, a0, 20
    andi a1, a1, 15
    jal putx_d
    srli a1, a0, 16
    jal putx_d
    srli a1, a0, 12
    andi a1, a1, 15
    jal putx_d
    srli a1, a0, 8
    andi a1, a1, 15
    jal putx_d
    srli a1, a0, 4
    andi a1, a1, 15
    jal putx_d
    andi a1, a0, 15
    jal putx_d
    
    li a0, '\r'
    sw a0, uart_fifo(t0)
    li a0, '\n'
    sw a0, uart_fifo(t0)
    
    lw ra, 0(sp)
    addi sp, sp, 16
    j halt
    # ret

putx_d:
    bltu a2, a1, putx_c
    addi a3, a1, '0'
    sw a0, uart_fifo(t0)
    ret
putx_c:
    addi a3, a1, 'A'-0xA
    sw a0, uart_fifo(t0)
    ret


isr:
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    la t0, uart0_base
    lw t1, uart_fifo(t0)
    sw t1, uart_fifo(t0)
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 16
    mret
