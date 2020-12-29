
.global gdtLoad
.extern gdtDesc 

gdtLoad:
    lgdt gdtDesc
    jmp $0x08, $.reload_CS
.reload_CS:
    mov $0x10, %ax 
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
