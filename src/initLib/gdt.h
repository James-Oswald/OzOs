
/** 
 * @file gdt.h 
 * @author James T Oswald
 * @brief This header library contains code for loading the Global Descriptor Table.
 * @details For information on why we need a global descriptor table and how we set it up, see:
 * <a href="https://wiki.osdev.org/LGDT">The OS dev GDT reffrence</a>,
 * <a href="https://wiki.osdev.org/GDT_Tutorial">The OS dev GDT tutorial</a>,
 * <a href="https://samypesse.gitbook.io/how-to-create-an-operating-system/chapter-6">This other tutorial</a>
 * */ 

#ifndef gdt_header
#define gdt_header

#include<int.h>

/**
 * @struct gdtDescriptor
 * @brief A structre representing a gdt table descriptor to be passed to lgdt and be stored in the gdtr.
 * @var gdtDescriptor::limit
 * @brief the size of the GDT in bytes, minus 1
 * @var gdtDescriptor::offset
 * @brief the location of the GDT in memory, basically a pointer to it.
 */
struct gdtDescriptor{
    u16 limit;
    u32 offset;
} __attribute__((packed));
typedef struct gdtDescriptor gdtDescriptor;

/**
 * @struct gdtEntry
 * @brief An entry in the GDT
 * @details entries are 8 bytes and contain information about memory segments.
 * for some reason these segments are stored all scrablmed, for the details on whats in here see 
 * <a href="https://wiki.osdev.org/LGDT">https://wiki.osdev.org/LGDT</a>
 * @var u16 gdtEntry::limit0_15
 * @brief first 2 bytes of the limit (size of the segment)
 * @var u16 gdtEntry::base0_15
 * @brief first 2 bytes of the base (start address of the segment)
 * @var u8 gdtEntry::base16_23
 * @brief third byte of the base (start address of the segment)
 * @var u8 gdtEntry::access
 * @brief access flags for the segment, includes the priv level. 
 * @var u8 gdtEntry::limit16_19
 * @brief final nibble of the limit (size of the segment)
 * @var u8 gdtEntry::flags
 * @brief even more flags for the segment, inclduing granularity and size
 * @var u8 gdtEntry::base24_31
 * @brief fourth byte of the base (start address of the segment)
 */
struct gdtEntry{
    u16 limit0_15;
    u16 base0_15;
    u8 base16_23;
    u8 access;
    u8 limit16_19 : 4;
    u8 flags : 4;
    u8 base24_31;
} __attribute__((packed));
typedef struct gdtEntry gdtEntry;

/**
 * @brief generates a new gdtEntry in memory at the provided address
 * @param entry the address to write the gdtEntry to
 * @param base the base address of the segment
 * @param size the size of the segment
 * @param access access flags
 * @param flags other flags
 */
void newGdtEntry(gdtEntry* entry, u32 base, u32 size, u8 access, u8 flags){
    entry->limit0_15 = (size & 0xffff);
    entry->base0_15 = (base & 0xffff);
    entry->base16_23 = (base & 0xff0000) >> 16;
    entry->access = access;
    entry->limit16_19 = (size & 0xf0000) >> 16;
    entry->flags = (flags & 0xf);
    entry->base24_31 = (base & 0xff000000) >> 24;
    return entry;
}

/**
 * @brief generates a new gdtDescriptor in memory at the provided address 
 * @param desc the address to write the gdtDescriptor to
 * @param base the base address of the gdt
 * @param size the TRUE size of the gdt
 */
void newGdtDescriptor(gdtDescriptor* desc, u32 base, u16 size){
    desc->offset = base;
    desc->limit = size - 1;
}

//This whole section should be fixed to have the globals be in the assembly
#define gdtSize 3               //!< the number of entries in the GDT 
gdtDescriptor gdtDesc;          //!< the memory storing the gdt descriptor to pass to lgdt
gdtEntry gdtRegistry[gdtSize];  //!< the memory storing the gdt itself

/** 
 * @brief The assembly proceduere to load the GDT.
 * @details Depends on the globals gdtDesc and gdtRegistry to be set.
 * Also reloads all segment registers
 */
extern void gdtLoad(); //from gdt.s

/**
 * @brief sets up the OS's GDT
 */
void gdtInit(){
    //to understand what all these random flags mean it is essentail to see GDT documentation
    // https://wiki.osdev.org/LGDT
    newGdtEntry(&gdtRegistry[0], 0, 0, 0, 0);
    newGdtEntry(&gdtRegistry[1], 0, 0xffffffff, 0b10011010, 0b1100); //code segment, offset 0x8
    newGdtEntry(&gdtRegistry[2], 0, 0xffffffff, 0b10010010, 0b1100); //data segment, offset 0x10

    //These were recomended by the tutorial, for some reason the granulatity bit needs to be set?
    //Without setting the granularity bit the longjump from gdtLoad fails.
    //newGdtEntry(&gdtRegistry[1], 0, 0xffffffff, 0x9A, 0xd); //code segment, offset 0x8
    //newGdtEntry(&gdtRegistry[2], 0, 0xffffffff, 0x92, 0xd); //data segment, offset 0x10
    newGdtDescriptor(&gdtDesc, (u32)&gdtRegistry, sizeof(gdtRegistry));
    gdtLoad(); //call the assembly method that actually loads the GDT in gtd.s
}

#endif