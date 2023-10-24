
MAKEFLAGS += --silent

.PHONY: all build clean run vis

all: run

build: bench.cpp top.sv
	verilator -Wno-fatal --trace-fst -sv --cc --exe --build -j $(shell nproc) -Wall bench.cpp top.sv -o sim

clean:
	rm -rf obj_dir

run: build
	./obj_dir/sim
