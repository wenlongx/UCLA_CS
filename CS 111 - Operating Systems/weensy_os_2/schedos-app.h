#ifndef WEENSYOS_SCHEDOS_APP_H
#define WEENSYOS_SCHEDOS_APP_H
#include "schedos.h"

/*****************************************************************************
 * schedos-app.h
 *
 *   System call functions and constants used by SchedOS applications.
 *
 *****************************************************************************/


// The number of times each application should run
#define RUNCOUNT	320


/*****************************************************************************
 * sys_yield
 *
 *   Yield control of the CPU to the kernel, which will pick another
 *   process to run.  (It might run this process again, depending on the
 *   scheduling policy.)
 *
 *****************************************************************************/

static inline void
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_YIELD)
		     : "cc", "memory");
}


/*****************************************************************************
 * sys_exit(status)
 *
 *   Exit the current process with exit status 'status'.
 *
 *****************************************************************************/

static inline void sys_exit(int status) __attribute__ ((noreturn));
static inline void
sys_exit(int status)
{
	// Different system call, different interrupt number (INT_SYS_EXIT).
	// This time, we also pass an argument to the system call.
	// We do this by loading the argument into a known register; then
	// the kernel can look up that register value to read the argument.
	// Here, the status is loaded into register %eax.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_EXIT),
		         "a" (status)
		     : "cc", "memory");
    loop: goto loop; // Convince GCC that function truly does not return.
}

#endif


/*****************************************************************************
 * sys_priority(???)
 *
 *   IF YOU IMPLEMENT EXERCISE 4.A, NAME YOUR SYSTEM CALL sys_priority .
 *
 *****************************************************************************/

static inline void
sys_priority(int priority)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_USER1.
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_USER1),
			     "a" (priority)
		     : "cc", "memory");
}


/*****************************************************************************
 * sys_share(???)
 *
 *   IF YOU IMPLEMENT EXERCISE 4.B, NAME YOUR SYSTEM CALL sys_share .
 *
 *****************************************************************************/

static inline void
sys_share(int share)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_USER2.
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_USER2),
			     "a" (share)
		     : "cc", "memory");
}


/*****************************************************************************
 * sys_replace_and_increment()
 *
 *    Replaces the print functionality in the skeleton code in schedos-1.c
 *
 *****************************************************************************/
static inline void
sys_replace_and_increment(uint16_t* volatile* addr, int printch, uint16_t incr_size)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_REPLACE_INCR
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_REPLACE_INCR),
			     "a" (addr),
				 "b" (printch),
				 "c" (incr_size)
		     : "cc", "memory");
}

/*****************************************************************************
 * sys_lottery()
 *
 *    sets the number of lottery tickets a process receives, for lottery scheduling
 *
 *****************************************************************************/
static inline void
sys_lottery(int num_tickets)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_LOTTERY
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_LOTTERY),
			     "a" (num_tickets)
		     : "cc", "memory");
}

/*****************************************************************************
 * sys_lock_acquire()
 * sys_lock_release()
 *
 *    acquires or releases the spinlock in schedos-kern.c
 *
 *****************************************************************************/
static inline void
sys_lock_acquire(int* lock)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_LOCK_ACQUIRE
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_LOCK_ACQUIRE),
			 	 "a" (lock)
		     : "cc", "memory");
}

static inline void
sys_lock_release(int* lock)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_LOCK_RELEASE
	asm volatile("int %0\n"
		     : : "i" (INT_SYS_LOCK_RELEASE),
			 	 "a" (lock)
		     : "cc", "memory");
}
