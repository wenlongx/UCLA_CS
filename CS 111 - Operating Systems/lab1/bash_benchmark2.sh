#!/usr/bin/bash

# Benchmark 2 #############################################
touch a
time bash sort -R words.txt | sort | tr a-z A-Z | comm words.txt - > a
rm a
