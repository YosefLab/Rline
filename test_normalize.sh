#!/bin/sh

test_cases=4
for i in `seq 1 $test_cases`
do 
	cmd="diff test_cases/r_outputs/normalize_$i.txt test_cases/ref_outputs/normalize_$i.txt"
	eval $cmd
done

