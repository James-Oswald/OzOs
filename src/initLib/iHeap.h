
/**  
 * @file iHeap.h 
 * @author James T Oswald
 * @deprecated
 * @breif This header library contains the worlds worst heap implementation.
 * 
 * This heap was designed to be used until I could set up the memory manager
 * however this proved to be unnecessary.
 * */ 

#ifndef initHeap_header
/** The include guard */
#define initHeap_header

#include<stddef.h>
#include<int.h>


#define initHeapSize 10000  //!< The max size of the heap in bytes 

u8 initHeap[initHeapSize] = {0};   //!< The heap
size_t initHeapIndex = 0;          //!< The current amount of allocated space in the heap

/**
 * @brief allocates a given number of bytes on the heap and returns a pointer
 * @param size the number of bytes to allocate
 * @return a void pointer to the allocated memory
 */
void* imalloc(size_t size){
    void* ptr = initHeap + initHeapIndex;
    initHeapIndex += size;
    return ptr;
}

#endif

