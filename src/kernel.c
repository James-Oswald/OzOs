#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <terminal.h>
#include <alert.h>
#include <multiboot.h>
#include <debug.h>

void kernelInit(){
	multibootSaveData();
}

void kernelMain(){
	//termPrint("Hello console");
	//dbgPrintMemory((void*)0x0);
}