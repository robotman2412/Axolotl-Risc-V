
MAKEFLAGS += --silent --no-print-directory

.PHONY: all build clean run wave

HDL =	hdl/top.sv \
		hdl/raw_block_ram.sv \
		../../axo_dev/hdl/main.sv \
		../../axo_dev/hdl/aligned_ram.sv \
		../../verilog/axo_memory.sv \
		../../verilog/axo_alu_rv32im.sv \
		../../verilog/axo_base.sv \
		../../verilog/axo_peripherals.sv \
		../../verilog/peripherals/uart.sv \
		../../verilog/axo_rv32im_zicsr.sv

SRC =	main.S

all: wave

build: $(HDL) $(shell find ../../verilog -type f) bench.cpp
	verilator -Wall -Wno-fatal -Wno-DECLFILENAME -Wno-VARHIDDEN -Wno-WIDTH -Wno-UNUSED \
		--trace-fst -sv --cc --exe --build \
		-I../../verilog/include \
		--top-module top \
		-j $(shell nproc) bench.cpp $(HDL) -o sim

clean:
	rm -rf obj_dir

run: build
	./obj_dir/sim

wave: run
	gtkwave obj_dir/sim.fst
