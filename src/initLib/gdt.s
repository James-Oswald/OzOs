.section .text
.global gdtLoad /* expose this for gdt.h */
.extern gdtDesc /* global from gdt.h */

gdtLoad:
    cli
    lgdt (gdtDesc)
    jmp $0x08, $.reload_CS  /* reload our $cs register with the new code segment */
.reload_CS:
    mov $0x10, %ax  /* set all our other segment registers to the new datasegment */
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    ret
