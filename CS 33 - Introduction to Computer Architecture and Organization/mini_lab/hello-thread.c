//Wenlong Xiong
//204407085

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

void *thread(void *vargp);

int main(int argc, const char *argv[])
{
    if (argc != 2)
        return 1;
    int x = atoi(argv[1]);
    pthread_t tid[x];

    for (int k = 0; k < x; k++)
    {
        pthread_create(&tid[k], NULL, thread, NULL);
    }
    for (int k = 0; k < x; k++)
    {
        pthread_join(tid[k], NULL);
    }
    return 0;
}

void *thread(void *vargp)
{
    printf("Hello, world!\n");
    return NULL;
}
