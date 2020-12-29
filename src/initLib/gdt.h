
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

//useful defines from the GDT_Tutorial for the flags to clog up my address space
#define SEG_DESCTYPE(x)  ((x) << 0x04) // Descriptor type (0 for system, 1 for code/data)
#define SEG_PRES(x)      ((x) << 0x07) // Present
#define SEG_SAVL(x)      ((x) << 0x0C) // Available for system use
#define SEG_LONG(x)      ((x) << 0x0D) // Long mode
#define SEG_SIZE(x)      ((x) << 0x0E) // Size (0 for 16-bit, 1 for 32)
#define SEG_GRAN(x)      ((x) << 0x0F) // Granularity (0 for 1B - 1MB, 1 for 4KB - 4GB)
#define SEG_PRIV(x)     (((x) &  0x03) << 0x05)   // Set privilege level (0 - 3)
 
#define SEG_DATA_RD        0x00 // Read-Only
#define SEG_DATA_RDA       0x01 // Read-Only, accessed
#define SEG_DATA_RDWR      0x02 // Read/Write
#define SEG_DATA_RDWRA     0x03 // Read/Write, accessed
#define SEG_DATA_RDEXPD    0x04 // Read-Only, expand-down
#define SEG_DATA_RDEXPDA   0x05 // Read-Only, expand-down, accessed
#define SEG_DATA_RDWREXPD  0x06 // Read/Write, expand-down
#define SEG_DATA_RDWREXPDA 0x07 // Read/Write, expand-down, accessed
#define SEG_CODE_EX        0x08 // Execute-Only
#define SEG_CODE_EXA       0x09 // Execute-Only, accessed
#define SEG_CODE_EXRD      0x0A // Execute/Read
#define SEG_CODE_EXRDA     0x0B // Execute/Read, accessed
#define SEG_CODE_EXC       0x0C // Execute-Only, conforming
#define SEG_CODE_EXCA      0x0D // Execute-Only, conforming, accessed
#define SEG_CODE_EXRDC     0x0E // Execute/Read, conforming
#define SEG_CODE_EXRDCA    0x0F // Execute/Read, conforming, accessed
 
#define GDT_CODE_PL0 SEG_DESCTYPE(1) | SEG_PRES(1) | SEG_SAVL(0) | \
                     SEG_LONG(0)     | SEG_SIZE(1) | SEG_GRAN(1) | \
                     SEG_PRIV(0)     | SEG_CODE_EXRD
 
#define GDT_DATA_PL0 SEG_DESCTYPE(1) | SEG_PRES(1) | SEG_SAVL(0) | \
                     SEG_LONG(0)     | SEG_SIZE(1) | SEG_GRAN(1) | \
                     SEG_PRIV(0)     | SEG_DATA_RDWR
 
#define GDT_CODE_PL3 SEG_DESCTYPE(1) | SEG_PRES(1) | SEG_SAVL(0) | \
                     SEG_LONG(0)     | SEG_SIZE(1) | SEG_GRAN(1) | \
                     SEG_PRIV(3)     | SEG_CODE_EXRD
 
#define GDT_DATA_PL3 SEG_DESCTYPE(1) | SEG_PRES(1) | SEG_SAVL(0) | \
                     SEG_LONG(0)     | SEG_SIZE(1) | SEG_GRAN(1) | \
                     SEG_PRIV(3)     | SEG_DATA_RDWR


#define gdtBase 0x00000800  //where we're putting our GDT in memory
#define gdtSize 6           //Number of entries in the GDT

typedef struct __attribute__((packed)){
    u16 limit;
    u32 offset;
} gdtDescriptor;

typedef struct __attribute__((packed)){
    u16 limit0_15;
    u16 base0_15;
    u8 base16_23;
    u8 acces;
    u8 limit16_19 : 4;
    u8 flags : 4;
    u8 base24_31;
} gdtEntry;


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

gdtDescriptor gdtDesc;
gdtEntry gdtRegistry[gdtSize];

void gdtInit(){
    newGdtEntry(&gdtRegistry[0], , u32 limit, u8 acces, u8 flags)
}

#endif