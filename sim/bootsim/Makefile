
MAKEFLAGS += --silent --no-print-directory

.PHONY: all build clean run wave

HDL = 	top.sv \
 		../memories.sv \
		../../verilog/axo_memory.sv \
		../../verilog/axo_alu_rv32im.sv \
		../../verilog/axo_base.sv \
		../../verilog/axo_rv32im_zicsr.sv

SRC =	main.S

all: wave

obj_dir/rom.sv: $(SRC)
	mkdir -p obj_dir
	riscv32-unknown-elf-gcc -g \
		-ffreestanding -nostdlib -nodefaultlibs \
		-march=rv32im_zicsr -mabi=ilp32 \
		-Tlinker.ld -o obj_dir/rom.elf $^
	riscv32-unknown-elf-objcopy -O binary obj_dir/rom.elf obj_dir/rom.bin
	../../tools/bin2rom.py obj_dir/rom.bin obj_dir/rom.sv rom 32
	riscv32-unknown-elf-objdump -t obj_dir/rom.elf

build: $(HDL) obj_dir/rom.sv $(shell find ../../verilog -type f) bench.cpp
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
