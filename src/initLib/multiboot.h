
//https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format

#ifndef multiboot_header
#define multiboot_header

#include<terminal.h>
#include<stdbool.h>
#include<int.h>
#include<debug.h>

typedef struct __attribute__((packed)){
    u32 size;
    u64 base;
    u64 length;
    u64 type;
} multibootMmapEntry;

extern u32* multibootTable;

inline bool multibootGetFlag(u8 index){
    return multibootTable[0] & (1<<index);
}

#define multibootMmapMaxEntries 10
multibootMmapEntry multibootMmapEntries[multibootMmapMaxEntries];

//this must be the first function called by the OS after getting
u32 multibootSaveData(){
    dbgPrintMemory(multibootTable);
    if(!multibootGetFlag(6))
        termError("flag 6 not set!");
        return 1;
    termError("meem!");
    u32 mmap_length = multibootTable[44];
    multibootMmapEntry* mmap_addr = (multibootMmapEntry*)(multibootTable[48] - 4);
    dbgPrintMemory((void*)mmap_addr);
    return 0;
}

#endif