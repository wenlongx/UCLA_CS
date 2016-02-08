#!/bin/sh

TOTAL_TESTS=0
SUCCEEDED_TESTS=0

function output_total() {
	echo -e "=============================================\n\
You passed $SUCCEEDED_TESTS/$TOTAL_TESTS tests";
}

function should_fail() {
  result=$?;
  echo -n "==> $1 ";
  if [ $result -lt 1 ]; then
    echo "FAILED";
	let "TOTAL_TESTS++"
  else
    echo "SUCCEEDED";
	let "TOTAL_TESTS++"
	let "SUCCEEDED_TESTS++"
  fi
}

function should_succeed() {
  result=$?;
  echo -n "==> $1 ";
  if [ $result -gt 0 ]; then
    echo "FAILED";
	let "TOTAL_TESTS++"
  else
    echo "SUCCEEDED";
	let "TOTAL_TESTS++"
	let "SUCCEEDED_TESTS++"
  fi
}

touch a b c
echo -e "a\nb\nc\nd" > a
echo "" > b
echo "" > c

./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 cat --wait | grep "0 cat" > /dev/null \
	&& (cat a | wc -l | grep 4 > /dev/null) \
	&& (cat b | wc -l | grep 4 > /dev/null) \
	&& (cat c | wc -l | grep 1 > /dev/null)
should_succeed "Command with no additional arguments:"
# expect b to be same as a, c to be empty
# expect 0 cat


echo "" >b
echo "" >c
./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 tr a-z A-Z --wait | grep "0 tr a-z A-Z" > /dev/null \
	&& (cat a | wc -l | grep 4 > /dev/null) \
	&& (cat b | wc -l | grep 4 > /dev/null) \
	&& (cat c | wc -l | grep 1 >/dev/null)
should_succeed "Command with additional arguments:"
# expect b to be upper case a, c to be empty
# expect 0 tr a-z A-Z


#echo "" >b
#echo "" >c
#./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 cat --command 0 1 2 tr a-z A-Z --command 0 1 2 cat --wait | grep -e "0 cat" -e "0 tr a-z A-Z" | wc -l | grep 3 >/dev/null \
#	&& (cat a | wc -l | grep 4 > /dev/null) \
#	&& (cat b | wc -l | grep 4 > /dev/null) \
#	&& (cat c | wc -l | grep 1 > /dev/null)
#should_succeed "Multiple commands:"


echo -e "e\nf\ng\nh" >b
echo "" >c
./simpsh --rdonly a --append --cloexec --wronly b --creat --excl --rdwr d --command 0 1 2 cat --wait | grep "0 cat" > /dev/null \
	&& (cat a | wc -l | grep 4 > /dev/null) \
	&& (cat b | wc -l | grep 8 > /dev/null) \
	&& (cat c | wc -l | grep 1 > /dev/null) \
	&& (cat d | wc -l | grep 0 > /dev/null)
should_succeed "O_APPEND, O_CLOEXEC, O_CREAT, O_EXCL options:"


#echo "" >b
#echo "" >c
#./simpsh --verbose --directory --rdonly a --wronly b --wronly c --command 0 1 2 cat > /dev/null \
#	&& (cat a | wc -l | grep 4 > /dev/null) \
#	&& (cat b | wc -l | grep 1 > /dev/null) \
#	&& (cat c | wc -l | grep 1 > /dev/null)
#should_fail "O_DIRECTORY option:"


echo "" >b
echo "" >c
./simpsh --verbose --nofollow --rdonly a --wronly b --wronly c --command 0 1 2 cat > /dev/null \
	&& (cat a | wc -l | grep 4 > /dev/null) \
	&& (cat b | wc -l | grep 1 > /dev/null) \
	&& (cat c | wc -l | grep 1 > /dev/null)
should_fail "O_NOFOLLOW option:"

# echo "" >b
# echo "" >c
# ./simpsh 

#./simpsh --verbose --rdonly a --wronly b --wronly c --pipe --command 0 4 2 cat --command 3 1 2 tr a-z A-Z --close 3 --close 4 --wait



output_total 
