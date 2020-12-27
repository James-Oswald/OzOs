
/*
    The multiboot header 
*/

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
    //termPrintInt(multibootTable[0]);
    //return multibootTable[0] >> (30 - index) & 1; 
    return multibootTable[0] >> (index - 1) & 1;
}

#define multibootMmapMaxEntries 10
u8 multibootNumMmapEntries = 0;
multibootMmapEntry multibootMmapEntries[multibootMmapMaxEntries] = {0};

//this must be the first function called by the OS after getting
u32 multibootSaveData(){
    //dbgPrintMemory(multibootTable);
    if(!multibootGetFlag(6)){
        termError("flag 6 not set!");
        return 1;
    }
    u32 mmap_length = multibootTable[11];
    //termPrintHex(mmap_length);
    //termPrintHex(multibootTable[12]);
    //multibootMmapEntry* mmap_addr = (multibootMmapEntry*)(multibootTable[12]); //dont do this, pointer arith adds the width of the struct
    u32 mmapIndex = 0;
    while(mmapIndex < mmap_length){
        multibootMmapEntry entry = *(multibootMmapEntry*)(multibootTable[12] + mmapIndex); //every day we stray farther from god
        mmapIndex += entry.size + 4;
        multibootMmapEntries[multibootNumMmapEntries] = entry;
        multibootNumMmapEntries++;
    }    
    //dbgPrintMemory((void*)mmap_addr);
    return 0;
}

void multibootPrintMmap(){
    char buffer[1000] = {0};
    u32 bufferIndex = 0;
    for(u8 i = 0; i < multibootNumMmapEntries; i++){
        strcpy(buffer + bufferIndex, "Entry:\n", 7);
        bufferIndex += 7;
        dbgWriteHex(buffer, &bufferIndex, 8, multibootMmapEntries[i].size);
        buffer[bufferIndex] = '\n';
        bufferIndex++;
        dbgWriteHex(buffer, &bufferIndex, 8, multibootMmapEntries[i].base);
        buffer[bufferIndex] = '\n';
        bufferIndex++;
        dbgWriteHex(buffer, &bufferIndex, 8, multibootMmapEntries[i].length);
        buffer[bufferIndex] = '\n';
        bufferIndex++;
        dbgWriteHex(buffer, &bufferIndex, 8, multibootMmapEntries[i].type);
        buffer[bufferIndex] = '\n';
        bufferIndex++;
    }
    buffer[bufferIndex] = '\0';
    termPrint(buffer);
}

#endif