
.PHONY: all build

all: run

build: simtest.sv
	@mkdir -p build
	@iverilog -i $^ -o build/sim.vvp

run: build
	vvp build/sim.vvp -fst
	gtkwave -6 build/sim.vcd
