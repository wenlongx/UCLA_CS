/*
    Wenlong Xiong
    204407085
    Lab 5
*/

#include <stdio.h>
#include <stdlib.h>

/*
    Returns an integer greater than, equal to, or less than 0 when the first
    n bytes of s1 are greater than, equal to, or less than s2, respectively
*/
int frobcmp(char const *a, char const *b) {
    int k = 0;
    while(k >= 0) {
        int A = a[k];
        int B = b[k];
        if ((A == ' ') && (B != ' ')) { return -1; }
        if ((B == ' ') && (A != ' ')) { return 1; }
        if ((A^42) > (B^42)) { return 1; }
        if ((A^42) < (B^42)) { return -1; }
        if ((A == ' ') && (B == ' ')) { return 0; }
        k++;
    }
    return 0;
}

/*
    Wrapper function for frobcmp()
*/
int cmp_wrapper(const void *a, const void *b) {
    const char *aa = *(const char **)a;
    const char *bb = *(const char **)b;
    return frobcmp(aa, bb);
}

int main()
{
    // Begins with a buffer of set size, expands if needed
    unsigned int buffer_size = 100000;
    char* buffer = (char*)malloc(buffer_size);
    char ch;
    unsigned int next = 0;
    while ((ch=getchar()) != EOF) {
        if (next >= buffer_size) {
            buffer_size += 100000;
            buffer = (char*)realloc(buffer, buffer_size);
        }
        buffer[next] = ch;
        next++;
    }
    next--;
    
    // figure out how much memory to allocate for pointer array
    int num_words = 0;
    for (unsigned int k = 0; k < next; k++) {
        if (buffer[k] == ' ') num_words++;
        if ((k == next-1) && (buffer[k] != ' ')) num_words++;
    }

    // array of pointers
    char** words = malloc(num_words * sizeof(char*));

    // allocate memory and populate array of strings
    int word_len = 0;
    int word_num = 0;
    for (unsigned int k = 0; k < next; k++) {
        // terminates with a space
        if (buffer[k] == ' ') {
            words[word_num] = (char*)malloc((word_len + 1)* sizeof(char));
            for (int j = 0; j <= word_len; j++) {
                words[word_num][j] = buffer[k-word_len+j];
            }
            word_len = 0;
            word_num++;
        }
        else word_len++;
        // doesn't terminate with a space
        if ((k == next-1) && (buffer[k] != ' ')) {
            words[word_num] = (char*)malloc((word_len + 1) * sizeof(char));
            for (int j = 0; j <= word_len; j++) {
                words[word_num][j] = buffer[k-word_len+j+1];
            }
            words[word_num][word_len + 1] = ' ';
        }
    }

    //sort array of c-strings
    qsort(words, num_words, sizeof(char*), cmp_wrapper);

    //outputs to stdout
    for (int i = 0; i < num_words; i++) {
        int j = 0;
        char c = words[i][j];
        while(c != ' ') {
            putchar(c);
            j++;
            c = words[i][j];
        }
        putchar(' ');
    }
    
    free(buffer);
    for (int k = 0; k < num_words; k++) {
        free(words[k]);
    }
    free(words);
    return 0;
}
