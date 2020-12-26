
#ifndef terminal_header
#define terminal_header

#include <stddef.h>
#include <stdint.h>
#include <vga.h>
#include <string.h>

static const size_t termWidth = 80;
static const size_t termHeight = 25;

size_t termRow;  		//the current row index
size_t termCol; 	//the current col index
uint8_t termColor;		//background color
uint16_t* termBuffer;	//pointer to the text buffer in memory


static inline uint8_t termColorCode(vgaColor fg, vgaColor bg){
	return fg | bg << 4;
}

static inline uint16_t termEntry(unsigned char character, uint8_t color){
	return (uint16_t)character | (uint16_t)color << 8;
}

void termInit(){
	termRow = 0;
	termCol = 0;
	termColor = termEntry(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	termBuffer = (uint16_t*)0xB8000; //litterally the hardware address for VGA mode 3 console buffer
	for (size_t y = 0; y < termHeight; y++) {
		for (size_t x = 0; x < termWidth; x++) {
			const size_t index = y * termWidth + x;
			termBuffer[index] = termEntry(' ', termColor);
		}
	}
}

void termSetColor(uint8_t color){
	termColor = color;
}

void termSetChar(char c, uint8_t color, size_t x, size_t y){
	const size_t index = y * termWidth + x;
	termBuffer[index] = termEntry(c, color);
}

void termPushChar(char c){
    switch(c){
    case '\n':
        termCol = 0;
        termRow++;
        return;
    case '\t':
        termCol = (termCol + 4 - termCol % 4);
        if(++termCol >= termWidth)
            termRow++;
        return;
    default:
        termSetChar(c, termColor, termCol, termRow);
        if (++termCol == termWidth){
            termCol = 0;
            if (++termRow == termHeight)
                termRow = 0;
        }
    }
}

void termPushString(const char* data, size_t size){
	for (size_t i = 0; i < size; i++)
		termPushChar(data[i]);
}
 
void termPrint(const char* data){
	termPushString(data, strLen(data));
}

#endif