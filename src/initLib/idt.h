/** 
 * @file idt.h 
 * @author James T Oswald
 * This header library contains code for loading the IDT 
 * 
 * @ref https://wiki.osdev.org/Interrupt_Descriptor_Table
 * @ref http://www.osdever.net/bkerndev/Docs/idt.htm
 * */ 

#include<int.h>

struct idtDescriptor{
    u16 limit;
    u32 offset;
} __attribute__((packed));
typedef struct idtDescriptor idtDescriptor;

void newIdtDescriptor(idtDescriptor* desc, u32 base, u16 size){
    desc->offset = base;
    desc->limit = size - 1;
}

struct idtGate{
    u16 offset0_15;
    u16 select;
    u16 type;
    u16 offset16_31;
} __attribute__((packed));
typedef struct idtGate idtGate;

void newGdtEntry(idtGate* gate, u32 base, u32 size, u8 access, u8 flags){
    gate->limit0_15 = (size & 0xffff);
    gate->base0_15 = (base & 0xffff);
    gate->base16_23 = (base & 0xff0000) >> 16;
    gate->access = access;
    gate->limit16_19 = (size & 0xf0000) >> 16;
    gate->flags = (flags & 0xf);
    gate->base24_31 = (base & 0xff000000) >> 24;
    return entry;
}


void irq0()