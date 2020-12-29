
/** 
 * @file multiboot.h 
 * @author James T Oswald
 * This header library contains code for storing retriving information provided to us by GRUB/any multiboot
 * standard complient bootloader.
 * see <a href="https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format"> 
 */ 

#ifndef multiboot_header
#define multiboot_header

#include<terminal.h>
#include<stdbool.h>
#include<int.h>
#include<debug.h>

/** 
 * @struct multibootMmapEntry
 * @brief A multiboot memory map entry.
 * @details Represents a contiguous chunk of memory and its availability status
 * See <a href="https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format">
 * this documentation </a> on mmap_addr.
 * @var multibootMmapEntry::size
 * @brief The size of the entry in bytes.
 * @details Minium of 20 bytes
 * @var multibootMmapEntry::base
 * @brief The start address of the memory chunk
 * @var u32 multibootMmapEntry::length
 * @brief The length of the memory chunk
 * @var multibootMmapEntry::type
 * @brief status of this memory chunk.
 * @details @remark a value of 1 indicates available RAM, 
 * value of 3 indicates usable memory holding ACPI information,
 * value of 4 indicates reserved memory which needs to be preserved on hibernation,
 * value of 5 indicates a memory which is occupied by defective RAM modules and
 * all other values currently indicated a reserved area.
 */

struct multibootMmapEntry{
    u32 size;   
    u64 base;
    u64 length; 
    u64 type;   
} __attribute__((packed));
typedef struct multibootMmapEntry multibootMmapEntry;

/** 
 * @brief A pointer to the Multiboot Information Structure
 * @details This is set externally in the assembly code in @ref boot.s 
 */
extern u32* multibootTable;

inline bool multibootGetFlag(u8 index){
    //termPrintInt(multibootTable[0]);
    //return multibootTable[0] >> (30 - index) & 1; 
    return multibootTable[0] >> (index - 1) & 1;
}

#define multibootMmapMaxEntries 10

/** The number of entries in the initial memory map. */
u8 multibootNumMmapEntries = 0;
/** Entries in the memory map */
multibootMmapEntry multibootMmapEntries[multibootMmapMaxEntries] = {0}; 

/** The number of free entries in the initial memory map.*/
u8 multibootNumFreeMmapEntries = 0;
/** Pointers to entries in @ref multibootMmapEntries of usable memory */
multibootMmapEntry* multibootFreeMmapEntries[multibootMmapMaxEntries] = {0}; //pointers to usable 

/** Save and format information from the Multiboot Information Structure.
 * Saves needed conent from the Multiboot information structure provided to us by GRUB stored in
 * EBX, see <a href="https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Machine-state">
 * the promised machine state</a> after a multiboot bootload. The most important thing this is used for
 * is retriving the usable memory map which we cant get anymore in protected mode since we cant run `int 0x15`.
 * 
 * @return Failure: 0 on sucess, 1 on failure
 */
u8 multibootSaveData(){
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

/** Simple debugging function for checking the memory map
 * 
 * 
 */ 
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