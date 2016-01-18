 /*
 * CS:APP Data Lab 
 * 
 * <Wenlong Xiong 204407085>
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
	/*
     * uses bitsmearing to convert the significant bits in a number to 1, and bit counting to count the number of 1's in a bitvector
     * special cases include negative numbers and numbers that require the full 32 bits
     */
    int t1, t2, mask1, mask2, mask3, mask4, mask5, y;
	// convert to positive integer
	t1 = (x >> 31);
	t2 = ((t1) << 1) ^ t1;
	x = (x ^ t1) + t2;
	// x now contains the abs value
	x = x + ~(1 & t1) + 1;
	// subtract 1 if negative, cuz negatives are off by 1 (start at -1)
	// 11 ops in this section
	
	x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);
	// x is now bitsmeared
	// for example:
	// 	0110 1100 became 0111 1111
	// 	0001 0111 became 0001 0111
	// 10 ops in this section
	
	mask1 = 0x55 | (0x55 << 8) | (0x55 << 16) | (0x55 << 24);
	mask2 = 0x33 | (0x33 << 8) | (0x33 << 16) | (0x33 << 24);
	mask3 = 0x0F | (0x0F << 8) | (0x0F << 16) | (0x0F << 24);
	mask4 = 0xFF | (0x00 << 8) | (0xFF << 16) | (0x00 << 24);
	mask5 = ((0xFF | (0xFF << 8)) | (0x00 << 16)) | (0x00 << 24);
	// 30 ops in this section
	
	// counting
	x = ((x >> 1) & mask1) + (x & mask1);
	x = ((x >> 2) & mask2) + (x & mask2);
	x = ((x >> 4) & mask3) + (x & mask3);
	x = ((x >> 8) & mask4) + (x & mask4);
	x = ((x >> 16) & mask5) + (x & mask5);
	// 20 ops in this section
	
	x = (x + 1);
	// assume every single bit has a signed bit, so one extra
	
    y = (x + (~32 + 1)) >> 31;
	// y is -1 if x is less than 32 bits long
	// if x is 32 bits long, then y returns 0
	// and in the below return statement, we 
	// return 32 instead of 33 (32 + 1)
	return (x & y) + (~y & 32);
}
/* 
 * sm2tc - Convert from sign-magnitude to two's complement
 *   where the MSB is the sign bit
 *   Example: sm2tc(0x80000005) = -5.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 4
 */
int sm2tc(int x) {
    /*
     * utilized the fact that -x = ~x + 1, and that unsigned positive #s are identical to their two's complement positive #s
     */
	int y = ~(1 << 31) & x;
	return (y & ~(x >> 31)) + ((x >> 31) & (~y + 1));
}
/* 
 * isNonNegative - return 1 if x >= 0, return 0 otherwise 
 *   Example: isNonNegative(-1) = 0.  isNonNegative(0) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 3
 */
int isNonNegative(int x) {
    /*
     * utilized the fact that all negative numbers begin with 1, as well as arithmetic shifts to create masks
     */
	return !(x & (1 << 31));
}

/*
 * rotateRight - Rotate x to the right by n
 *   Can assume that 0 <= n <= 31
 *   Examples: rotateRight(0x87654321,4) = 0x18765432
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 25
 *   Rating: 3 
 */
int rotateRight(int x, int n) {
    /*
     * used arithmetic shifts to create masks, and utilized bitshifting to move rotate x (after masking)
     */
	int mask = ((1 << 31) >> (31 + ~n + 1));
	return (((x & mask) >> n) & ~(((1 << 31) >> n) << 1)) | ((x & ~mask) << (32 + ~n + 1));
}
/* 
 * divpwr2 - Compute x/(2^n), for 0 <= n <= 30
 *  Round toward zero
 *   Examples: divpwr2(15,1) = 7, divpwr2(-33,4) = -2
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 2
 */
int divpwr2(int x, int n) {
    /*
     * uses shifts to divide by a power of two, and uses the leftmost bit to determine the sign of the number
     */
	int a = ((x >> 31) & ((1 << n) + ~0));
	return ((x + a) >> n);
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
    /*
     * a word masked by all the odd bits (0xAAAAAAAA) should just be all odd bits if odd bits in the word are set to 1
     */
	int y = (0xAA | (0xAA << 8));
	y = (y | (y << 16));
	return !((x & y) ^ y);
}
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
    /*
     * Finds AND, NAND, then finds the overlap between ~AND and ~NAND to find XOR
     */
	return ~(x&y) & ~(~x&~y);
}
/*
 * isTmin - returns 1 if x is the minimum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmin(int x) {
    /*
     * uses the fact that only Tmin and 0, when doubled, equals 0; also uses the fact that Tmin != 0x00
     */
	return !(x+x) & !!x;
}
