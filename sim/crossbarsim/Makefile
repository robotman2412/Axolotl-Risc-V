
MAKEFLAGS += --silent --no-print-directory

.PHONY: all build clean run wave

HDL = 	top.sv \
 		../memories.sv \
		../../verilog/axo_memory.sv \
		../../verilog/axo_alu_rv32im.sv \
		../../verilog/axo_base.sv \
		../../verilog/axo_rv32im_zicsr.sv

all: wave

build: $(HDL) $(shell find ../../verilog -type f) bench.cpp
	mkdir -p build
	verilator -Wall -Wno-fatal -Wno-DECLFILENAME -Wno-VARHIDDEN -Wno-WIDTH -Wno-UNUSED \
		--trace-fst -sv --cc --exe --build \
		-I.. -I../../verilog \
		--top-module top \
		-j $(shell nproc) bench.cpp $(HDL) -o sim

clean:
	rm -rf obj_dir

run: build
	./obj_dir/sim

wave: run
	gtkwave obj_dir/sim.fst
