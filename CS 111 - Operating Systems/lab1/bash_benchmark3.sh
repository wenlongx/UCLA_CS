#!/usr/bin/bash

# Benchmark 3 #############################################
time bash ls -Ral /usr/local/cs | tr ' ' '\n' | sort | wc -l
