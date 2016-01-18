/*
    Wenlong Xiong
    204407085
    Lab 5
*/

#include <stdio.h>
#include <stdlib.h>


int main()
{
    for(int k = 0; k < 256; k++) {
        // generateds frobnicated octal
        //printf("\\\\%o", k^42);

        // generates octal of all 256 ASCII Characters
        printf("\\\\%o", k);
    }
}
