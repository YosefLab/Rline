#!/bin/sh

./clean.sh
test_cases=4

for i in `seq 1 $test_cases`
do
	echo "Training Vector Concatenate Line Case $i:"
	cmd=" Rscript caller.R --command concatenate --input_file_1 ./test_cases/ref_inputs/line_1_$i.txt --input_file_2 ./test_cases/ref_inputs/line_2_$i.txt --output_file ./test_cases/r_outputs/concatenate_$i.txt"
	eval $cmd
done

for i in `seq 1 $test_cases`
do
	echo "Training Original Concatenate Line Case $i:"
	cmd="./concatenate -input1 ./test_cases/ref_inputs/line_1_$i.txt -input2 ./test_cases/ref_inputs/line_2_$i.txt -output ./test_cases/ref_outputs/concatenate_$i.txt"
	eval $cmd
done
