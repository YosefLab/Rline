#!/bin/sh

if [ $# -ne 7 ]
then
	binary=0
	dim=5
	order=2
	num_negative=5
	samples=1 
	rho=0.025
    	threads=1
else
	binary=$1
	dim=$2
	order=$3
	num_negative=$4
	samples=$5
	rho=$6
	threads=$7
fi

test_cases=4
for i in `seq 1 $test_cases`
do
	cmd="./line -train ./test_cases/ref_inputs/reconstruct$i.txt -output ./test_cases/ref_inputs/line_1_$i.txt -size $dim -order 1 -negative $num_negative -samples $samples -rho $rho -threads $threads"
	eval $cmd
	cmd="./line -train ./test_cases/ref_inputs/reconstruct$i.txt -output ./test_cases/ref_inputs/line_2_$i.txt -size $dim -order 2 -negative $num_negative -samples $samples -rho $rho -threads $threads"
	eval $cmd
done
