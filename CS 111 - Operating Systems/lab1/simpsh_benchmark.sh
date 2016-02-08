#!/bin/sh

# Benchmark 1 ######################################################
#rm a b c d
#touch a b c d
#./simpsh --verbose --profile --rdonly words.txt --rdwr a --rdwr b --rdwr c --rdwr d --command 0 1 4 tr a-z A-Z --command 3 2 4 comm words.txt a --wait

# Benchmark 2 ######################################################
#rm a b c d
#touch a b c
#./simpsh --verbose --profile --rdonly words.txt --wronly a --wronly b --pipe --pipe --pipe --command 0 4 2 sort -R --command 3 6 2 sort --command 5 8 2 tr a-z A-Z --command 7 1 2 comm words.txt - --wait 

# Benchmark 3 ######################################################
#rm a b c d
#./simpsh --verbose --profile --creat --wronly a --pipe --pipe --pipe --creat --rdonly b --creat --wronly c --command 7 2 0 ls -Ral /usr/local/cs --command 1 4 0 tr ' ' '\n' --command 3 6 0 sort --command 5 8 0 wc -l --wait
