
.PHONY: all build clean run wave

HDL = 	top.sv \
 		../memories.sv \
		../../verilog/axo_alu_rv32im.sv \
		../../verilog/axo_base.sv \
		../../verilog/axo_rv32im_zicsr.sv

SRC =	main.S

all: wave

build/rom.sv: $(SRC)
	@mkdir -p build
	@riscv32-unknown-elf-gcc -ffreestanding -nostdlib -nodefaultlibs -march=rv32im_zicsr -mabi=ilp32 -Tlinker.ld -o build/rom.elf $^
	@riscv32-unknown-elf-objcopy -O binary build/rom.elf build/rom.bin
	@../bin2rom.py build/rom.bin build/rom.sv rom 16
	@riscv32-unknown-elf-objdump -t build/rom.elf

build/sim.vvp: $(HDL) build/rom.sv
	@mkdir -p build
	@iverilog -g2012 -I. -I../../verilog $(HDL) -o build/sim.vvp

build: build/sim.vvp

clean:
	rm -rf build

run: build
	vvp build/sim.vvp -fst

wave: run
	gtkwave build/sim.vcd
