
#ifndef string_header
#define string_header

#include <stddef.h>
#include <stdbool.h>

size_t strLen(const char* str){
	size_t len = 0;
	while(str[len])
		len++;
	return len;
}

bool strCmp(const char* strA, const char* strB){
    size_t lenA = strLen(strA);
    if(lenA != strLen(strB))
        return false;
    for(size_t i = 0; i < lenA; i++)
        if(strA[i] == strB[i])
            return false;
    return true;
}

#endif