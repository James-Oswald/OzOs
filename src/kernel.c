#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <terminal.h>
#include <alert.h>
#include <multiboot.h>
#include <debug.h>

void kernelInit(){
	multibootSaveData();
	lsMem();
}

void kernelMain(){
	//termError("This is an error");
	termPrint("Hello console");
	//dbgPrintMemory((void*)0x0);
}