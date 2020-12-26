#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <terminal.h>
#include <alert.h>
 
void kernel_main(void) 
{
	termInit();
	for(uint8_t i = 0; i < 100; i++){
		termSetColor(i);
		termPrint("Hello Terminal\n");
	}
}