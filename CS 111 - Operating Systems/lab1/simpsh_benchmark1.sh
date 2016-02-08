#!/bin/sh

# Benchmark 1 ######################################################
touch a b c d
./simpsh --verbose --profile --rdonly words.txt --rdwr a --rdwr b --rdwr c --rdwr d --command 0 1 4 tr a-z A-Z --command 3 2 4 comm words.txt a --wait
rm a b c d
