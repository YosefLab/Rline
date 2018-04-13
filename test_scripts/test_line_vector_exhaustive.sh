#!/bin/bash

binary=("0" "0" "0" "0" "0" "0" "0" "0")
dim=("100" "1" "10" "100" "1" "10" "100" "1")
order=("2" "1" "2" "1" "2" "1" "2" "1")
negative=("5" "1" "5" "25" "1" "5" "25" "1")
sample=("1" "5" "25" "1" "5" "25" "1" "5")
rho=("0.025" "0.001" "0.01" "0.05" "0.1" "0.5" "0" "0")
threads=("1" "1" "1" "1" "1" "1" "5" "20")
test_cases=8
passed_cases=0


for (( i=1; i < ${test_cases}+1; i++ ));
do 
	cmd="./train_line_vector.sh ${binary[$i-1]} ${dim[$i-1]} ${order[$i-1]} ${negative[$i-1]}
	   ${sample[$i-1]} ${rho[$i-1]} ${threads[$i-1]}"
	eval $cmd
	result=`./test_line.sh | wc -l`
	if [ $result -eq 4 ]
	then 
		echo "Passed Test Case $i"
		passed_cases=$((passed_cases+1))
	else 
		echo "Failed Test Case $i"
		result=`./test_line.sh`
		echo $result
	fi        	
done

echo "Passed $passed_cases/$test_cases Test Cases"

