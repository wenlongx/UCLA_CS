#include <stdio.h>

int main (int argc, char *argv[]) {
    // check that there are 3 arguments
    if (argc != 3) return 1;
    char* from = argv[1];
    char* to = argv[2];

    // check to see that the two strings are the same length
    int k = 0;
    while ((from[k] != '\0') && (to[k] != '\0')) { k++;}
    if (from[k] != to[k]) return 1;
    
    // check that there are no duplicates in 'from'
    for (int i = 0; i < k; i++) {
        for (int j = i + 1; j < k; j++) {
            if (from[i] == from[j]) return 1;
        }
    }
    
    char ch;
    while ((ch=getchar()) != EOF) {
        for (int j = 0; j < k; j++) {
            if (ch == from[j]) { ch = to[j]; break; }
        }
        putchar(ch);
    }
    
    return 0;
}
