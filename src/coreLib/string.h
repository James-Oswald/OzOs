
#ifndef string_header
#define string_header

#include <stddef.h>
#include <stdbool.h>
#include <int.h>

size_t strLen(char* str){
	size_t len = 0;
	while(str[len])
		len++;
	return len;
}

char* strcpy(char* dst, char* src, u64 n){
	for(u64 i = 0; i < n; i++)
        dst[i] = src[i];
	return dst;
}

bool strCmp(char* strA, char* strB){
    size_t lenA = strLen(strA);
    if(lenA != strLen(strB))
        return false;
    for(size_t i = 0; i < lenA; i++)
        if(strA[i] == strB[i])
            return false;
    return true;
}

#endif