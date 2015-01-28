OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

ENTRY(_start)

SECTIONS
{
  . = 0x8000000;
  start_addr = .;
  .text.start : { *(.text.start) }
  .text       : { *(.text) *(.text*) }
  .rodata     : { *(.rodata) *(.rodata*) }
  .data       : { *(.data) *(.data*) }
  .bss        : { *(.bss) *(.bss*) }
  . = ALIGN(32);
  /*.stack : {
    stack_start = .;
    . += 0x10000;
    . = ALIGN(32);
    stack_end = .;
  }*/
  total_size = . - start_addr;
}
