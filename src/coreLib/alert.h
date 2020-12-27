
//Very basic warning system that dosn't depend on the terminal code to display alerts to the VGA console

#include<string.h>
#include<stddef.h>
#include<stdint.h>

void alert(char* str, uint8_t color){
    uint16_t* buffer = (uint16_t*)0xB8000;
    for(size_t i = 0; i < strLen(str); i++)
        buffer[i] = str[i] | color << 8;
}

void alertError(char* str){
    alert(str, 0x4f); //white text red background
}

void alertWarning(char* str){
    alert(str, 0xef); //white text yellow background
}