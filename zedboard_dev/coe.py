
# This work ("Axolotl³²") is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike 4.0 International License:
#
# https://creativecommons.org/licenses/by-nc-sa/4.0/

def encode(data: list, cols: int = 32):
	"""Writes a .coe string to be imported from some form of FPGA project."""
	out = "memory_initialization_radix = 16;\nmemory_initialization_vector =\n"
	# Count max digit requirement.
	digits = max(1, max((n.bit_length() + 3) // 4 for n in data))
	# Write some stuf.
	for i in range(len(data)):
		if i < len(data) - 1:
			out += "{:x}".format(data[i]).rjust(digits, '0')+','
			out += ' ' if i % cols != cols - 1 else '\n'
		else:
			out += "{:x}".format(data[i]).rjust(digits, '0')+';\n'
	# Return some stuf.
	return out

def write(path: str, data: list, cols: int = 32):
	"""Writes a .coe file to be imported from some form of FPGA project."""
	fd=open(path, "w")
	fd.write(encode(data, cols))
	fd.close()
