#!/bin/sh

./clean.sh
test_cases=4

for i in `seq 1 $test_cases`
do
	echo "Training Vector Concatenate Line Case $i:"
	cmd="Rscript caller.R --command normalize --input_file ./test_cases/ref_inputs/concatenate_$i.txt --output_file ./test_cases/r_outputs/normalize_$i.txt"
	eval $cmd
done

for i in `seq 1 $test_cases`
do
	echo "Training Original Concatenate Line Case $i:"
	cmd="./normalize -input ./test_cases/ref_inputs/concatenate_$i.txt -output ./test_cases/ref_outputs/normalize_$i.txt"
	eval $cmd
done
