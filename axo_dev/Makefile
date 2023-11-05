
MAKEFLAGS += --no-print-directory

.PHONY: all build clean

all: build

build:
	@mkdir -p build
	@cmake -B build
	@cmake --build build

clean:
	rm -rf build
