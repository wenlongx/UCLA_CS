#!/bin/sh
# Benchmark 3 ######################################################
./simpsh --verbose --profile --creat --wronly a --pipe --pipe --pipe --creat --rdonly b --creat --wronly c --command 7 2 0 ls -Ral /usr/local/cs --command 1 4 0 tr ' ' '\n' --command 3 6 0 sort --command 5 8 0 wc -l --wait
