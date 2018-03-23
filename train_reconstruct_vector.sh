#!/bin/sh

#max_k then max_depth
./clean.sh
test_cases=4

if [ $# -ne 2 ]
then
	max_depth=1
	max_k=0
else
	max_depth=$1
	max_k=$2
fi

for i in `seq 1 $test_cases`
do
	echo "Training Vector Reconstruct Case $i:"
	cmd="./reconstruct_vector -train ./test_cases/cases/test$i.txt -output ./test_cases/r_outputs/reconstruct$i.txt -depth $max_depth -threshold $max_k"
	eval $cmd
done

for i in `seq 1 $test_cases`
do
	echo "Training Original Reconstruct Case $i:"
	cmd="./reconstruct -train ./test_cases/cases/test$i.txt -output ./test_cases/ref_outputs/reconstruct$i.txt -depth $max_depth -threshold $max_k"
	eval $cmd
done
