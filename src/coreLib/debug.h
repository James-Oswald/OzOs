
#ifndef debug_header
#define debug_header


#include<stddef.h>
#include<int.h>
#include<terminal.h>

void dbgWriteHex(char* buffer, u32* offset, u32 length, u32 val){
    static char* codes = "0123456789abcdef";
    for(u32 i = 0; i < length; i++)
        buffer[*offset + i] = codes[val >> ((length - i - 1) * 4) & 0xf];
    *offset += length;
}

void dbgPrintMemory(void* from){
    char buffer[1000];
    strcpy(buffer, "\n          ", 11);
    u32 bufferIndex = 11;
	for(u8 i = 0; i < 16; i++){
        dbgWriteHex(buffer, &bufferIndex, 2, (u32)from % 16 + i);
        buffer[bufferIndex] = ' ';
        bufferIndex++;
    }
    buffer[bufferIndex] = '\n';
    bufferIndex++;
    for(u8 i = 0; i < 10; i++){
        dbgWriteHex(buffer, &bufferIndex, 8, (u32)from + i * 16);
        buffer[bufferIndex] = '|';
        bufferIndex++;
        buffer[bufferIndex] = ' ';
        bufferIndex++;
        for(u8 j = 0; j < 16; j++){
            dbgWriteHex(buffer, &bufferIndex, 2, ((u8*)from)[i * 16 + j]);
            buffer[bufferIndex] = ' ';
            bufferIndex++;
        }
        strcpy(buffer + bufferIndex, "    ", 4);
        bufferIndex += 4;
        for(u8 j = 0; j < 16; j++){
            char c = ((char*)from)[i * 16 + j];
            buffer[bufferIndex] = c >= 32 && c <= 126 ? c : '.';
            bufferIndex++;
        }
        buffer[bufferIndex] = '\n';
        bufferIndex++;
    }
    buffer[bufferIndex] = '\0';
    bufferIndex++;
    termPrint(buffer);
}

#endif