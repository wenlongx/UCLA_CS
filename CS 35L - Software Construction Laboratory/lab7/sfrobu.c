/*
    Wenlong Xiong
    204407085
    Lab 7
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int num_comparisons = 0;

// Returns an integer greater than, equal to, or less than 0 when the first
// n bytes of s1 are greater than, equal to, or less than s2, respectively
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

// Wrapper function for frobcmp()
int cmp_wrapper(const void *a, const void *b) {
    const char *aa = *(const char **)a;
    const char *bb = *(const char **)b;
    num_comparisons++;
    return frobcmp(aa, bb);
}

int main()
{
    // Begins with a buffer of set size, expands if needed
    struct stat f;
    if (fstat(0, &f) == -1) { exit(1); }
    int buffer_size = f.st_size;
    char* buffer = (char*)malloc(buffer_size * sizeof(char));
    char ch[1];
    unsigned int next = 0;

    // use read() instead of getchar()
    while ((0 < read(0, ch, 1)) && (ch[0] != EOF)) {
        if (next >= buffer_size) {
            buffer_size += 1000000;
            buffer = (char*)realloc(buffer, buffer_size);
        }
        buffer[next] = ch[0];
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

    char space[1];
    space[0] = ' ';
    //outputs to stdout
    for (int i = 0; i < num_words; i++) {
        int j = 0;
        char c = words[i][j];
        while(c != ' ') {
            write(1, &c, 1);
            j++;
            c = words[i][j];
        }
        write(1, space, 1);
    }

    // print out number of comparisons
    if (!fprintf(stderr, "Comparisons: %d\n", num_comparisons)) exit(1);
    
    free(buffer);
    for (int k = 0; k < num_words; k++) {
        free(words[k]);
    }
    free(words);
    return 0;
}
