
#ifndef mem_header
#define mem_header

#include<int.h>

void* memcpy(u8* dst, u8* src, u64 n){
	for(u64 i = 0; i < n; i++)
        dst[i] = src[i];
	return dst;
}

#endif