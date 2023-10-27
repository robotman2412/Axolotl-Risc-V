
MAKEFLAGS += --silent --no-print-directory

SRCS = src/main.S

.PHONY: all build clean

all: build

build: $(SRCS)
	mkdir -p build
	riscv32-unknown-elf-gcc -g \
		-ffreestanding -nostdlib -nodefaultlibs \
		-march=rv32im_zicsr -mabi=ilp32 \
		-Tlinker.ld -o build/rom.elf $^
	riscv32-unknown-elf-objcopy -O binary build/rom.elf build/rom.bin
	../../tools/bin2coe.py build/rom.bin build/rom.coe 32

clean:
	rm -rf build
