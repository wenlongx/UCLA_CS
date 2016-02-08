#!/usr/bin/bash

# Benchmark 1 #############################################
# touch a b
#(tr a-z A-Z <words.txt) > a && comm words.txt a > b
# rm a b

# Benchmark 1 #############################################
#touch a
#sort -R words.txt | sort | tr a-z A-Z | comm words.txt - > a
#rm a

# Benchmark 1 #############################################
#ls -Ral /usr/local/cs | tr ' ' '\n' | sort | wc -l
