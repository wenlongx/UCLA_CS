/* CS 111 Winter 2016
 * Lab 4
 *
 * Wenlong Xiong
 * UID: 204407085
 *
 * Michael Xiong
 * UID: 404463570
 *
 */

#include "SortedList.h"
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <pthread.h>

void SortedList_insert(SortedList_t *list, SortedListElement_t *element);

// Global variable and constant declarations
long long BILLION = 1000000000LLU;
int num_sublists;
// 0	no locking
// 1	--sync=m	mutex lock
// 2	--sync=s	spin lock
int lock_mechanism;
pthread_mutex_t mutex_lock;
volatile int spin_lock;
int opt_yield = 0;

// Thread information struct
struct thread_info {
	int iter;
	int sublists;
	SortedListElement_t** elements;
	SortedList_t** list;
	// deprecated: 
	long long time_ns;
};

//generates a random string
char *randstring(size_t length) {

    static char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.-#'?!";        
	char *randomString = NULL;

	if (length) {
		randomString = malloc(sizeof(char) * (length +1));

		if (randomString) {            
			int n;
			for (n = 0;n < length;n++) {            
				int key = rand() % (int)(sizeof(charset) -1);
				randomString[n] = charset[key];
			}

		randomString[length] = '\0';
		}
	}

	return randomString;
}

// Thread function
void* sltest_thread(void* information) {

	struct timespec start, end;
	clock_gettime(CLOCK_MONOTONIC, &start);
	
	int k;
	struct thread_info* info = (struct thread_info*) information;
	
	info->list = (SortedList_t**)malloc(info->sublists*sizeof(SortedList_t *));


	// initialize list heads
	for (k = 0; k < info->sublists; k++) {
		SortedList_t* sublist = malloc(sizeof(SortedList_t));

		info->list[k] = sublist;

		info->list[k]->next = NULL;
		info->list[k]->prev = NULL;
		info->list[k]->key = NULL;
	}

	

	// do your stuff
	// insert
	for (k = 0; k < info->iter; k++) {
		int listNo = info->elements[k]->key[0] % info->sublists;
		// lock
		if (lock_mechanism == 1) pthread_mutex_lock(&mutex_lock);
		if (lock_mechanism == 2) while(__sync_lock_test_and_set(&spin_lock, 1));
		SortedList_insert(info->list[listNo], info->elements[k]);
		// unlock
		if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
		if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
	}
	// length
	for (k = 0; k < info->sublists; k++) {
		// lock
		if (lock_mechanism == 1) pthread_mutex_lock(&mutex_lock);
		if (lock_mechanism == 2) while(__sync_lock_test_and_set(&spin_lock, 1));
		if (SortedList_length(info->list[k]) == -1) {
			// unlock
			if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
			if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
			fprintf(stderr, "List pointers corrupted during length check.\n");
			exit(1);
		}
		// unlock
		if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
		if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
	}
	// lookup
	for (k = 0; k < info->iter; k++) {
		int listNo = info->elements[k]->key[0] % info->sublists;
		// lock
		if (lock_mechanism == 1) pthread_mutex_lock(&mutex_lock);
		if (lock_mechanism == 2) while(__sync_lock_test_and_set(&spin_lock, 1));
		SortedList_lookup(info->list[listNo], info->elements[k]->key);
		// unlock
		if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
		if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
	}
	// delete
	for (k = 0; k < info->iter; k++) {
		// lock
		if (lock_mechanism == 1) pthread_mutex_lock(&mutex_lock);
		if (lock_mechanism == 2) while(__sync_lock_test_and_set(&spin_lock, 1));
		if (SortedList_delete(info->elements[k]) == 1) {
			// unlock
			if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
			if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
			fprintf(stderr, "List pointers corrupted.\n");
			exit(1);
		}
		// unlock
		if (lock_mechanism == 1) pthread_mutex_unlock(&mutex_lock);
		if (lock_mechanism == 2) __sync_lock_release(&spin_lock);
	}
	
	clock_gettime(CLOCK_MONOTONIC, &end);
	info->time_ns = (long long) (BILLION*(end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec));
	return;
}

int main(int argc, char** argv) {
	static int getopt_return = -1;
	int num_iterations = 1;	// default number of iterations is 1
	int num_threads = 1;	// default number of threads is 1
	num_sublists = 1;		// default number of sublists is 1
	lock_mechanism = 0;		// default is no locking

	// Argument options
	static struct option long_options[] = {
		{ "iterations", required_argument, &getopt_return, 0 },
		{ "threads", required_argument, &getopt_return, 1 },
		{ "yield", required_argument, &getopt_return, 2 },
		{ "sync", required_argument, &getopt_return, 3 },
		{ "lists", required_argument, &getopt_return, 4 },
		{ 0, 0, 0, 0 }
	};

	// Parse arguments
	while (1) {
		int option_index = 0;
		getopt_return = -1;
		if (optind >= argc) break;
		getopt_long(argc, argv, "", long_options, &option_index);
		if (getopt_return == -1) {
			break;
		}

		switch (getopt_return) {
			case 0:
				num_iterations = atoi(optarg);
				break;
			case 1:
				num_threads = atoi(optarg);
				break;
			case 2:
				;
				int k = 0;
				while(optarg[k] != '\0') {
					if (optarg[k] == 'i') {
						opt_yield = opt_yield | INSERT_YIELD;
					} else if (optarg[k] == 'd') {
						opt_yield = opt_yield | DELETE_YIELD;
					} else if (optarg[k] == 's') {
						opt_yield = opt_yield | SEARCH_YIELD;
					} else {
						fprintf(stderr, "Invalid --yield argument\n");
						exit(1);
					}
					k++;
				}
				break;
			case 3:
				if (optarg[0] == 'm') {
					lock_mechanism = 1;
				} else if (optarg[0] == 's') {
					lock_mechanism = 2;
				}
				break;
			case 4:
				num_sublists = atoi(optarg);
				break;
			default:
				break;
		}
	}

	// Operations
	int num_ops = (num_threads * num_iterations * 3 * num_iterations / num_sublists);

	// Overall timing
	struct timespec start, end;
	clock_gettime(CLOCK_MONOTONIC, &start);
	long long elapsed_time = 0;
	long long average_time = 0;

	
	pthread_t threads[num_threads];
	struct thread_info info[num_threads];
	int k;
	for (k = 0; k < num_threads; k++) {
		info[k].iter = num_iterations;
		info[k].time_ns = 0;
		info[k].elements = (SortedListElement_t**) malloc(sizeof(SortedListElement_t*) * num_iterations);
		int j;
		for (j = 0; j < num_iterations; j++) {
			struct SortedListElement *element = malloc(sizeof(SortedListElement_t));

			element->next = NULL;
			element->prev = NULL;
			element->key = randstring(5);
			info[k].elements[j] = element;
		}
		info[k].sublists = num_sublists;
	}


	// Locking requirements
	spin_lock = 0;
	if (lock_mechanism == 1) {
		if (pthread_mutex_init(&mutex_lock, NULL) != 0) {
			fprintf(stderr, "Error: unable to initialize pthread_mutex\n");
			exit(1);
		}
	}

	// Initialize threads
	int rc;
	for (k = 0; k < num_threads; k++) {
		rc = pthread_create(&threads[k], NULL, sltest_thread, &info[k]);
		if (rc) {
			fprintf(stderr, "Error: unable to create thread\n");
			exit(1);
		}
	}
	
	// Join threads
	for (k = 0; k < num_threads; k++) {
		rc = pthread_join(threads[k], NULL);
		if (rc) {
			fprintf(stderr, "Error: unable to join thread\n");
			exit(1);
		}
	}
	for (k = 0; k < num_threads; k++) {
		free(info[k].elements);
	}

	// Locking requirements
	if (lock_mechanism == 1) {
		pthread_mutex_destroy(&mutex_lock);
	}

	// Overall timing
	clock_gettime(CLOCK_MONOTONIC, &end);
	elapsed_time = (long long) (BILLION*(end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec));
	average_time = elapsed_time / num_ops;
	printf("%i threads x %i iterations x (insert + lookup + delete = 3) x (%i/%i avg len) = " \
		"%i operations\n", num_threads, num_iterations, num_iterations, num_sublists,  num_ops);

	
	printf("elapsed time: %llu ns\n", elapsed_time);
	printf("per operation: %llu ns\n", average_time); 

	int j;
	int num_errors = 0;
	for (k = 0; k < num_threads; k++) {
		for (j = 0; j < num_sublists; j++) {
			int l = SortedList_length(info[k].list[j]);
			if (l != 0) {
				fprintf(stderr, "Error, thread %i has List of length %i\n", k, l);
				num_errors++;
			}
		}
	}

	if (num_errors > 0)
		exit(1);
	else
		exit(0);

}
