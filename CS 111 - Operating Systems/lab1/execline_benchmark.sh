#!/usr/local/cs/execline-2.1.4.5/bin/execlineb

# Benchmark 1 #############################################
#foreground { redirfd -w 1 a pipeline { cat words.txt } pipeline { tr a-z A-Z } cat } redirfd -w 1 b pipeline { comm words.txt a } cat

# Benchmark 2 #############################################
#redirfd -w 1 a pipeline { sort -R words.txt } pipeline { sort } pipeline { tr a-z A-Z } pipeline { comm words.txt - } cat

# Benchmark 3 #############################################
#redirfd -w 1 c pipeline { ls -Ral /usr/local/cs } pipeline { tr " " "\n" } pipeline { sort } pipeline { wc -l } cat
