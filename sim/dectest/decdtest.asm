
LC0:
	.zero 4
	# 00200193
	addi x3, x0, 2
	# 00209093
	slli x1, x1, 2
	# 00000497
	auipc x9, 0
	# ff84a083
	lw x1, -8(x9)
