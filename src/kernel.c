
/** 
 * @file multiboot.h 
 * @author James T Oswald
 * This header library contains code for loading the Global Descriptor Table.
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <gdt.h>
#include <terminal.h>
#include <alert.h>
#include <multiboot.h>
#include <debug.h>


/**
 * This is the first thing called after boot, the only two things that
 * happen before this function are setting up the stack and saving the
 * multiboot 
 * 
 * 
 */
void kernelInit(){
	multibootSaveData();
	gdtInit();
	//multibootPrintMmap();
}

void kernelMain(){
	//termError("This is an error");
	termPrint("Hello IEEE");
	termError("This project was a mistake");
	//dbgPrintMemory((void*)0x0);
}