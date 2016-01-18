/*
Wenlong Xiong
204407085

A)
%esi holds the value of x
%ebx holds the value of n
%edi holds the value of result
%edx holds the value of mask

B)
Initial value of result is -1
Initial value of mask is 1

C)
The test condition for mask is that mask != 0

D)
Mask = mask shifted left by n

E)
Result is XOR'ed with (mask & x)

F)
*/

int loop(int x, int n)
{
    int result = -1;
    int mask;
    for (mask = 1; mask != 0; mask <<= n) {
        result ^= (mask & x);
    }
    return result;
}
