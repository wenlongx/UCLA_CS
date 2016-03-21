CC = gcc
CFLAGS = -lrt

default: 
	$(CC) $(CFLAGS) sltest.c SortedList.c -o sltest

sltest:
	$(CC) $(CFLAGS) sltest.c SortedList.c -o sltest

addtest: addtest.c
	$(CC) $(CFLAGS) addtest.c -o addtest

clean:
	rm -rf sltest addtest *.o a.out

