#include "schedos-app.h"
#include "x86sync.h"

/*****************************************************************************
 * schedos-1
 *
 *   This tiny application prints red "1"s to the console.
 *   It yields the CPU to the kernel after each "1" using the sys_yield()
 *   system call.  This lets the kernel (schedos-kern.c) pick another
 *   application to run, if it wants.
 *
 *   The other schedos-* processes simply #include this file after defining
 *   PRINTCHAR appropriately.
 *
 *****************************************************************************/

#ifndef PRINTCHAR
#define PRINTCHAR	('1' | 0x0C00)
#endif

// for EXERCISE 4A
#ifndef PROCESS_PRIORITY
#define PROCESS_PRIORITY 1
#endif

// for EXERCISE 4B
#ifndef PROCESS_SHARE
#define PROCESS_SHARE 1
#endif



// UNCOMMENT THE NEXT LINE TO USE EXERCISE 8 CODE INSTEAD OF EXERCISE 6
#define __EXERCISE_8__
// Use the following structure to choose between them:
#ifndef __EXERCISE_8__
// (exercise 6 code)
void print_to_screen(uint16_t * volatile* cursorpos_ptr, int printch) {
	sys_replace_and_increment(cursorpos_ptr, printch, 1);
}
#else
// (exercise 8 code)
void print_to_screen(uint16_t * volatile* cursorpos_ptr, int printch) {
	int k;
	while (1) {
		sys_lock_acquire(&k);
		if (k == 1) break;
		sys_yield();
	}
	*(*cursorpos_ptr)++ = printch;
	k = 0;
	sys_lock_release(&k);
	if (k != 1) sys_exit(1);
}
#endif



void
start(void)
{

	// EXERCISE 4A/B code
	sys_priority(PROCESS_PRIORITY);
	sys_share(PROCESS_SHARE);

	// EXERCISE 7 code
	sys_lottery(PROCESS_SHARE);

	// EXERCISE 4A/B code
	sys_yield();

	int i;

	for (i = 0; i < RUNCOUNT; i++) {
		// Write characters to the console, yielding after each one.

		// EXERCISE 6 and EXERCISE 8
		print_to_screen(&cursorpos, PRINTCHAR);

		/*
		skeleton code that was given
		*cursorpos++ = PRINTCHAR;
		*/

		sys_yield();
	}


	// EXERCISE 2 Code
	// exit process when done
	sys_exit(0);

	// Skeleton code
	// Yield forever.
	while (1)
		sys_yield();
}
