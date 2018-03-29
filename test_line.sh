#!/bin/sh

test_cases=4
for i in `seq 1 $test_cases`
do 
	echo "Test Case $i:"
	cmd="diff test_cases/r_outputs/line$i.txt test_cases/ref_outputs/line$i.txt"
	eval $cmd
done

