
#ifndef initHeap_header
#define initHeap_header

#include<stddef.h>
#include<int.h>

#define initHeapSize 10000  //the size of the heap in bytes

u8 initHeap[initHeapSize] = {0};
size_t initHeapIndex = 0;

void* imalloc(size_t size){
    void* ptr = initHeap + initHeapIndex;
    initHeapIndex += size;
    return ptr;
}

#endif

