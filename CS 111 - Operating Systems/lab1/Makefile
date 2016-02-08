
name = lab1-wenlong_xiong-michael_xiong
CC = gcc
OPTIMIZE = -O2
CFLAGS = -g3 -Wall -std=c11 $(OPTIMIZE)

default: simpsh.c
	$(CC) $(CFLAGS) simpsh.c -o simpsh

clean:
	rm -rf *.o *~ *.tar.gz *.tmp a.out simpsh lab1-wenlong_xiong-michael_xiong/
	rm -rf a b c d e

check:
	chmod +x test.sh
	rm -rf a b c d e
	echo "======> test cases for simpsh"
	./test.sh
	echo "======> timing simpsh benchmarks (1,2,3)"
	time ./simpsh_benchmark1.sh
	time ./simpsh_benchmark2.sh
	time ./simpsh_benchmark3.sh
	rm -rf a b c
	echo "=====> timing bash benchmarks (1,2,3)"
	time ./bash_benchmark1.sh
	time ./bash_benchmark2.sh
	time ./bash_benchmark3.sh
	echo "=====> timing execline benchmarks (1,2,3)"
	time execlineb execline_benchmark1
	time execlineb execline_benchmark2
	time execlineb execline_benchmark3

directory: clean
	mkdir $(name)
	cp constants.h $(name)/constants.h
	cp simpsh.c $(name)/simpsh.c
	cp README $(name)/README
	cp Makefile $(name)/Makefile
	cp test.sh $(name)/test.sh
	cp simpsh_benchmark1.sh $(name)/simpsh_benchmark1.sh
	cp simpsh_benchmark2.sh $(name)/simpsh_benchmark2.sh
	cp simpsh_benchmark3.sh $(name)/simpsh_benchmark3.sh
	cp bash_benchmark1.sh $(name)/bash_benchmark1.sh
	cp bash_benchmark2.sh $(name)/bash_benchmark2.sh
	cp bash_benchmark3.sh $(name)/bash_benchmark3.sh
	cp execline_benchmark1 $(name)/execline_benchmark1
	cp execline_benchmark2 $(name)/execline_benchmark2
	cp execline_benchmark3 $(name)/execline_benchmark3
	cp words.txt $(name)/words.txt
	cp profile_benchmark.pdf $(name)/profile_benchmark.pdf

dist: directory
	tar -cvzf lab1-wenlong_xiong-michael_xiong.tar.gz lab1-wenlong_xiong-michael_xiong/
