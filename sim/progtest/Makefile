
.PHONY: all run build hexdump clean

all: build hexdump run

build: build/sim

build/sim: verilog/progtest.v build/program.v ../../verilog/*.v ../*.v
	@mkdir -p build
	iverilog -I../../verilog -I.. -Iverilog -Ibuild -o $@ $<

build/program.v: build/program.bin
	@mkdir -p build
	@echo "// WARNING: This is a generated file, do not edit it!" > $@
	@echo "module program(input wire[31:0] addr, output wire[31:0] data);" >> $@
	@echo -e "\twire[31:0] rom[$(shell stat -c%s $<)/4-1:0];" >> $@
	@hexdump -ve "\"\tassign rom[%_ad/4] = \" /4 \"'h%08x\" \";\n\"" $< >> $@
	@echo -e "\tassign data = addr < ($(shell stat -c%s $<)/4) ? rom[addr] : 0;" >> $@
	@echo "endmodule" >> $@

build/program.bin: build/program.elf
	@mkdir -p build
	riscv32-unknown-elf-objcopy -O binary $< $@

build/program.elf: src/main.s
	@mkdir -p build
	riscv32-unknown-elf-gcc \
		-nodefaultlibs -nostdlib \
		-fPIE -static-pie \
		-march=rv32i -mabi=ilp32 \
		-o $@ $<

hexdump:
	@echo -e "\n\nProgram data:"
	@hexdump -ve '"  %02_ax: " /4 "%08x " "\n"' build/program.bin
	@echo -e "\n"

run:
	vvp build/sim

clean:
	rm -rf build
