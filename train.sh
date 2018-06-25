#!/bin/sh

#old line compilation
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result line.cpp -o line -lgsl -lm -lgslcblas
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result reconstruct.cpp -o reconstruct
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result normalize.cpp -o normalize
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result concatenate.cpp -o concatenate

#new line compilation with less compiler options
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops line.cpp -o line -lgsl -lm -lgslcblas
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops reconstruct.cpp -o reconstruct
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops normalize.cpp -o normalize
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops concatenate.cpp -o concatenate

#line compilation with vector inputs
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops line_vector.cpp -o line_vector -lgsl -lm -lgslcblas
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops reconstruct_vector.cpp -o reconstruct_vector
g++ -lm -pthread -Wall -Wno-unused-result -funroll-loops concatenate_vector.cpp -o concatenate_vector


#example of original line algorithm
./reconstruct -train net_youtube.txt -output net_youtube_dense.txt -depth 2 -k-max 1000
./line -train net_youtube_dense.txt -output vec_1st_wo_norm.txt -binary 1 -size 128 -order 1 -negative 5 -samples 10000 -threads 40
./line -train net_youtube_dense.txt -output vec_2nd_wo_norm.txt -binary 1 -size 128 -order 2 -negative 5 -samples 10000 -threads 40
./normalize -input vec_1st_wo_norm.txt -output vec_1st.txt -binary 1
./normalize -input vec_2nd_wo_norm.txt -output vec_2nd.txt -binary 1
./concatenate -input1 vec_1st.txt -input2 vec_2nd.txt -output vec_all.txt -binary 1

#example of line algorithm with vector inputs and outputs
./reconstruct_vector -train net_youtube.txt -output net_youtube_dense.txt -depth 2 -k-max 1000
./line_vector -train net_youtube_dense.txt -output vec_1st_wo_norm.txt -binary 1 -size 128 -order 1 -negative 5 -samples 10000 -threads 40
./line_vector -train net_youtube_dense.txt -output vec_2nd_wo_norm.txt -binary 1 -size 128 -order 2 -negative 5 -samples 10000 -threads 40
./concatenate_vector -input1 vec_1st.txt -input2 vec_2nd.txt -output vec_all.txt -binary 1

#example of line algorithm with R wrapper functions
Rscript caller.R --command reconstruct --input_file ./test_cases/cases/test_1.txt --output_file ./test_cases/r_outputs/reconstruct_1.txt  --max_depth 1 --max_k 0
Rscript caller.R --command line --input_file ./test_cases/ref_inputs/reconstruct_1.txt --output_file ./test_cases/r_outputs/line_1_1.txt --binary 0 --dim 5 --order 1 --negative 5 --samples 5 --rho 0.025 --threads 1
Rscript caller.R --command line --input_file ./test_cases/ref_inputs/reconstruct_1.txt --output_file ./test_cases/r_outputs/line_2_1.txt --binary 0 --dim 5 --order 2 --negative 5 --samples 5 --rho 0.025 --threads 1
Rscript caller.R --command concatenate --input_file_1 ./test_cases/ref_inputs/line_1_1.txt --input_file_2 ./test_cases/ref_inputs/line_2_1.txt --output_file ./test_cases/r_outputs/concatenate_1.txt
Rscript caller.R --command normalize --input_file ./test_cases/ref_inputs/concatenate_1.txt --output_file ./test_cases/r_outputs/normalize_1.txt

#example of line algorithm with different output formats
Rscript caller.R --command reconstruct --input_file ./test_cases/cases/test_1.txt --output_file ./test_cases/r_outputs/reconstruct_1.txt  --max_depth 1 --max_k 0 --output_format 2
Rscript caller.R --command reconstruct --input_file ./test_cases/cases/test_1.txt --output_file ./test_cases/r_outputs/reconstruct_1.rds  --max_depth 1 --max_k 0 --output_format 3

