
#[[
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
#]]

cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_C_COMPILER "riscv32-unknown-elf-gcc")
set(CMAKE_EXPORT_COMPILE_COMMANDS true)
set(target rom.elf)

project(axo_dev_rom C ASM)

add_compile_options(
    -ffreestanding -nostdlib -nodefaultlibs
    -march=rv32im_zicsr -mabi=ilp32
)

add_link_options(
    -ffreestanding -nostdlib -nodefaultlibs
    -T${CMAKE_CURRENT_LIST_DIR}/linker.ld
)

add_executable(${target}
    src/main.S
)
