
/*
    This work ("Axolotl³²") is licensed under a Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International License:
    
    https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

PHDRS
{
	codeseg   PT_LOAD;
	rodataseg PT_LOAD;
	dataseg   PT_LOAD;
}

SECTIONS
{
	/DISCARD/ : { *(.note.gnu.build-id) }
    
    . = 0;
    
    __start_text = .;
    .text : { *(.text) } :codeseg
    __stop_text = .;
    
    __start_rodata = .;
    .rodata : { *(.rodata) *(.srodata) } :rodataseg
    __stop_rodata = .;
    
    __start_data = .;
    .data : { *(.data) *(.sdata) } :dataseg
    __stop_data = .;
    
    __start_bss = .;
    .bss : { *(.bss) *(.sbss) } :NONE
    __stop_bss = .;
}

ENTRY(_start)