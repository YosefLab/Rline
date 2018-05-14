#!/bin/sh

./clean.sh
test_cases=4

if [ $# -ne 7 ]
then
	binary=0
	dim=100
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

echo "binary = $binary"
echo "dim = $dim"
echo "order = $order"
echo "num_negative = $num_negative"
echo "samples = $samples"
echo "rho = $rho"
echo "threads = $threads"

for i in `seq 1 $test_cases`
do
	echo "Training Vector Line Case $i:"
	cmd="Rscript ../caller.R --command line --input_file ../test_cases/ref_inputs/reconstruct_$i.txt --output_file ../test_cases/r_outputs/line_$i.txt --binary $binary --dim $dim --order $order --negative $num_negative --samples $samples --rho $rho --threads $threads --output_format 2"
	eval $cmd
done

for i in `seq 1 $test_cases`
do
	echo "Training Original Line Case $i:"
	cmd="../line -train ../test_cases/ref_inputs/reconstruct_$i.txt -output ../test_cases/ref_outputs/line_$i.txt -binary $binary -size $dim -order $order -negative $num_negative -samples $samples -rho $rho -threads $threads"
	eval $cmd
done

