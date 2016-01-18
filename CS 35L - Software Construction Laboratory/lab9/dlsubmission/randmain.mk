randlibhw.o: randlibhw.c
	$(CC) $(CFLAGS) -c -fPIC randlibhw.c -o randlibhw.o
randlibsw.o: randlibsw.c
	$(CC) $(CFLAGS) -c -fPIC randlibsw.c -o randlibsw.o

randlibhw.so: randlibhw.o
	$(CC) $(CFLAGS) randlibhw.o -shared -o randlibhw.so
randlibsw.so: randlibsw.o
	$(CC) $(CFLAGS) randlibsw.o -shared -o randlibsw.so

randcpuid.o: randcpuid.c
	$(CC) $(CFLAGS) -c randcpuid.c -o randcpuid.o
ramdmain.o: randmain.c
	$(CC) $(CFLAGS) -c randmain.c -o randmain.o
randmain: randcpuid.o randmain.o
	$(CC) $(CFLAGS) -ldl -Wl,-rpath=$(PWD) -o randmain randcpuid.o randmain.o
