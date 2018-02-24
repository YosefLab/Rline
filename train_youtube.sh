#!/bin/sh

g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result line.cpp -o line -lgsl -lm -lgslcblas
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result reconstruct.cpp -o reconstruct
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result normalize.cpp -o normalize
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result concatenate.cpp -o concatenate

./reconstruct -train ./test_cases/cases/net_youtube.txt -output ./test_cases/ref_outputs/net_youtube_dense.txt -depth 2 -threshold 1000
./line -train ./test_cases/ref_outputs/net_youtube_dense.txt -output ./test_cases/ref_outputs/vec_1st_wo_norm.txt -binary 0 -size 128 -order 1 -negative 5 -samples 10000 -threads 40
./line -train ./test_cases/ref_outputs/net_youtube_dense.txt -output ./test_cases/ref_outputs/vec_2nd_wo_norm.txt -binary 0 -size 128 -order 2 -negative 5 -samples 10000 -threads 40
./normalize -input ./test_cases/ref_outputs/vec_1st_wo_norm.txt -output ./test_cases/ref_outputs/vec_1st.txt -binary 0
./normalize -input ./test_cases/ref_outputs/vec_2nd_wo_norm.txt -output ./test_cases/ref_outputs/vec_2nd.txt -binary 0
./concatenate -input1 ./test_cases/ref_outputs/vec_1st.txt -input2 ./test_cases/ref_outputs/vec_2nd.txt -output ./test_cases/ref_outputs/vec_all.txt -binary 0

