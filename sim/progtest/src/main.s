
	.text
	.global _start
_start:
	addi x1, x0, 0xa0
	addi x2, x0, 0x11
	sw x2, 0(x1)
	lw x3, 0(x1)
