#!/bin/sh

# Benchmark 2 ######################################################
touch a b c
./simpsh --verbose --profile --rdonly words.txt --wronly a --wronly b --pipe --pipe --pipe --command 0 4 2 sort -R --command 3 6 2 sort --command 5 8 2 tr a-z A-Z --command 7 1 2 comm words.txt - --wait 
rm a b c
