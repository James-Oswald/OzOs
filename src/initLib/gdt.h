
/** 
 * @file multiboot.h 
 * @author James T Oswald
 * This header library contains code for loading the Global Descriptor Table.
 * 
 * @ref https://wiki.osdev.org/Interrupt_Descriptor_Table
 * @ref http://www.osdever.net/bkerndev/Docs/idt.htm
 * */ 

//https://wiki.osdev.org/LGDT
//https://wiki.osdev.org/GDT_Tutorial
//https://samypesse.gitbook.io/how-to-create-an-operating-system/chapter-6

#ifndef gdt_header
/** The include guard */
#define gdt_header

#include<int.h>

struct gdtDescriptor{
    u16 limit;
    u32 offset;
} __attribute__((packed));
typedef struct gdtDescriptor gdtDescriptor;

struct gdtEntry{
    u16 limit0_15;
    u16 base0_15;
    u8 base16_23;
    u8 acces;
    u8 limit16_19 : 4;
    u8 flags : 4;
    u8 base24_31;
} __attribute__((packed));
typedef struct gdtEntry gdtEntry;

gdtEntry* newGdtEntry(gdtEntry* entry, u32 base, u32 limit, u8 acces, u8 flags){
    entry->limit0_15 = (limit & 0xffff);
    entry->base0_15 = (base & 0xffff);
    entry->base16_23 = (base & 0xff0000) >> 16;
    entry->acces = acces;
    entry->limit16_19 = (limit & 0xf0000) >> 16;
    entry->flags = (flags & 0xf);
    entry->base24_31 = (base & 0xff000000) >> 24;
    return entry;
}

gdtDescriptor* newGdtDescriptor(gdtDescriptor* desc, u16 limit, u32 offset){
    desc->limit = limit;
    desc->offset = offset;
}

#define gdtSize 3
gdtDescriptor gdtDesc;
gdtEntry gdtRegistry[gdtSize];

extern void gdtLoad();

void gdtInit(){
    newGdtEntry(&gdtRegistry[0], 0, 0, 0, 0);
    newGdtEntry(&gdtRegistry[1], 0, 0xffffffff, 0b10011010, 0b0100); //code segment, offset 0x8
    newGdtEntry(&gdtRegistry[2], 0, 0xffffffff, 0b10011010, 0b0100); //data segment, offset 0x10
    gdtDesc.limit = sizeof(gdtRegistry) - 1;
    gdtDesc.offset = (u32)&gdtRegistry;
    gdtLoad();
}

#endif