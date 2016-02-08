#!/usr/bin/bash

# Benchmark 1 #############################################
touch a b
(tr a-z A-Z<words.txt) > a && comm words.txt a > b
rm a b
