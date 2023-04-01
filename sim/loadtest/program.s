
_start:
	addi x1, zero, 0x21		# 02100093
	add  x2, x1, x1			# 00108133
	srli x3, x2, 1			# 00115193
	lui  x4, 0xf00dc		# f00dc237
	addi x4, x4, 0xfffffabe	# abe20213
