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


void SortedList_insert(SortedList_t* list, SortedListElement_t* element) {
	// if list is null, then new element is equal to the entirety of the list
	if (list->next == NULL) {
		element->next = NULL;
		element->prev = list;
		if (opt_yield & INSERT_YIELD) pthread_yield();
		list->next = element;
		
		return;
	}

	while (list->next != NULL && element->key > list->next->key) {
		list = list->next;
	}

	// insert
	element->next = list->next;
	element->prev = list;
	if (opt_yield & INSERT_YIELD) pthread_yield();
	if (element->next != NULL)
		list->next->prev = element;
	list->next = element;

	return;
}

int SortedList_delete(SortedListElement_t* element) {
	// if element is the last element
	if (element->next == NULL) {
		// only check previous pointer integrity
		if (element->prev->next != element || element->prev->key > element->key) {

			return 1;
		}
		else {
			if (opt_yield & DELETE_YIELD) pthread_yield();
			element->prev->next = element->next;

			return 0;
		}
	}
	// element is first or middle element
	else {
		// check to make sure this element is properly linked right now
		if (element->next->prev != element 
			|| element->prev->next != element 
			|| element->next->key < element->key
			|| (element->prev->key != NULL && element->prev->key > element->key)) {

			// not properly linked, corrupted pointers
			return 1;
		}
		else {
			element->prev->next = element->next;
			if (opt_yield & DELETE_YIELD) pthread_yield();
			element->next->prev = element->prev;

			return 0;
		}
	}

}

SortedListElement_t* SortedList_lookup(SortedList_t* list, const char* key) {
	while (list != NULL && list->key != key) 
		list = list->next;
	if (opt_yield & SEARCH_YIELD) pthread_yield();

	SortedListElement_t* retval;
	retval = (list == NULL) ? NULL : list;

	return retval;
}

int SortedList_length(SortedList_t* list) {
	if (list->next == NULL) {
		return 0;
	}
	
	int length = 1;
	SortedListElement_t* prev = list;
	list = list->next;

	while (list->next != NULL) {
		if (list->prev != prev 
			|| prev->next != list
			|| (list->prev->key != NULL && list->prev->key > list->key)) {

			return -1;
		}

		length++;
		prev = list;
		if (opt_yield & SEARCH_YIELD) pthread_yield();
		list = list->next;
	}

	return length;
}
