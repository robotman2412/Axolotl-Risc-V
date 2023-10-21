
.PHONY: all build clean run

SRCS = 	top.sv \
		../../verilog/axo_alu_rv32im.sv \
		../../verilog/axo_base.sv \
		../../verilog/axo_rv32im_zicsr.sv

all: run

build: $(SRCS)
	@mkdir -p build
	@iverilog -I. -I../../verilog $(SRCS) -o build/sim.vvp

clean:
	rm -rf build

run: build
	vvp build/sim.vvp -fst
	gtkwave -6 build/sim.vcd
