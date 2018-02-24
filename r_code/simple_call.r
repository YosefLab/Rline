#!/usr/bin/env Rscript

#This function makes system calls to the Line Package and compiles the Line Algorithm in C++
#After running this function you can just run the executables of the Line Algorithm 
#in your current working directory by calling line, reconstruct, concatenate, or normalize
#You must have the gsl package installed in the C++ library for this program to work for linux environments
#dir takes in the directory where the C++ code for the LINE algorithm is relative to your current working directory
#C++ Commands run using this function
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result line.cpp -o line -lgsl -lm -lgslcblas
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result reconstruct.cpp -o reconstruct
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result normalize.cpp -o normalize
#g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result concatenate.cpp -o concatenate
compile <- function(dir = "./") {
  compile_line <- "g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result"
  compile_line <- paste(compile_line, dir, sep = " ")
  compile_line <- paste(compile_line, "line.cpp -o line -lgsl -lm -lgslcblas" , sep = "")
  system(paste(compile_line))

  compile_reconstruct <- "g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result"
  compile_reconstruct <- paste(compile_reconstruct, dir, sep = " ")
  compile_reconstruct <- paste(compile_reconstruct, "reconstruct.cpp -o reconstruct", sep = "")
  system(paste(compile_reconstruct))

  compile_normalize <- "g++ -lm -ptvhread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result"
  compile_normalize <- paste(compile_normalize, dir, sep = " ")
  compile_normalize <- paste(compile_normalize, "normalize.cpp -o normalize", sep = "")
  system(paste(compile_normalize))

  compile_concatenate <- "g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result"
  compile_concatenate <- paste(compile_concatenate, dir, sep = " ")
  compile_concatenate <- paste(compile_concatenate, "concatenate.cpp -o concatenate", sep = "")
  system(paste(compile_concatenate))
  return
}


  
#This function makes system calls to the Line Package to run the LINE algorithm in C++
#Pass in the destination of the input file relative to your current working directory as train tag
#All arguments that you may pass in are: (from Line Package)
#-train, the input file
#-output, the output file of the embedding;
#-binary, whether saving the output file in binary mode; the default is 0 (off);
#-size, the dimension of the embedding; the default is 100;
#-order, the order of the proximity used; 1 for first order, 2 for second order; the default is 2;
#-negative, the number of negative samples used in negative sampling; the default is 5;
#-samples, the total number of training samples (*Million);
#-rho, the starting value of the learning rate; the default is 0.025;
#-threads, the total number of threads used; the default is 1.
line <- function(train, output, binary = 0, size = 5, order = 2, negative = 2, samples = 3, rho = 0.025, threads = 10) {
  cmd <- paste(sprintf("./line -train %s -output %s -binary %d -size %d -order %d -negative %d -samples %d -threads %d", train, output, binary, size, order, negative, samples, threads))
  system(cmd)
  #cat(cmd, '\n')
  return
}

#Reconstruct function 
#parameters for training are:
#-train, input file
#-output, output file
#-depth, the maximum depth in the Breadth-First-Search, default is 0
#-threshold, For vertex whose degree is less than <int>, we will expand its neighbors until the degree reaches <iny>
#example: ./reconstructls -train net.txt -output net_dense.txt -depth 2 -threshold 1000
reconstruct <- function(train, output, depth = 0, threshold = 1000) {
  cmd <- paste(sprintf("./reconstruct -train %s -output %s -depth %d -threshold %d", train, output, depth, threshold))
  #cat(cmd, '\n')
  system(cmd)
  return
}

#Normalize function 
#parameters for training are:
#-train, input file
#-output, output file
#-binary, Save the learnt embeddings in binary moded; default is 0
normalize <- function(train, output, binary = 0) {
  cmd <- paste(sprintf("./normalize -input %s -output %s -binary %d", train, output, binary))   
  #cat(cmd, '\n')
  system(cmd)
  return
}

#Concatenate function 
#parameters for training are:
#-train, input file
#-output, output file
#-binary, Save the learnt embeddings in binary moded; default is 0
concatenate <- function(input1, input2, output, binary = 0) {
  cmd <- paste(sprintf("./concatenate -input1 %s -input2 %s -output %s -binary %d", input1, input2, output, binary))   
  #cat(cmd, '\n')
  system(cmd)
  return
}


test_1 <- function(input_path, path) {
  reconstruct(train = paste0(input_path, "test1.txt"), output = paste0(path, "test1_re.txt"))
  line(train = paste0(path, "test1_re.txt"), output = paste0(path, "test_1_1st_wo_norm.txt")) #./test_cases/ref_outputs/
  line(train = paste0(path, "test1_re.txt"), output = paste0(path, "test_1_2nd_wo_norm.txt")) #./test_cases/ref_outputs/
  normalize(train = paste0(path, "test_1_1st_wo_norm.txt"), output = paste0(path, "test_1_1st.txt"), binary = 0)
  normalize(train = paste0(path, "test_1_2nd_wo_norm.txt"), output = paste0(path, "test_1_2nd.txt"), binary = 0)
  concatenate(input1 = paste0(path, "test_1_1st.txt"), input2 = paste0(path, "test_1_2nd.txt"), output = "../test_cases/ref_outputs/test_1_all.txt", binary = 0) 
}

test_2 <- function(input_path, path) {
  reconstruct(train = paste0(input_path, "test2.txt"), output = paste0(path, "test2_re.txt"))
  line(train = paste0(path, "test2_re.txt"), output = paste0(path, "test_2_1st_wo_norm.txt")) #./test_cases/ref_outputs/
  line(train = paste0(path, "test2_re.txt"), output = paste0(path, "test_2_2nd_wo_norm.txt")) #./test_cases/ref_outputs/
  normalize(train = paste0(path, "test_2_1st_wo_norm.txt"), output = paste0(path, "test_2_1st.txt"), binary = 0)
  normalize(train = paste0(path, "test_2_2nd_wo_norm.txt"), output = paste0(path, "test_2_2nd.txt"), binary = 0)
  concatenate(input1 = paste0(path, "test_2_1st.txt"), input2 = paste0(path, "test_2_2nd.txt"), output = "../test_cases/ref_outputs/test_2_all.txt", binary = 0)
}

test_3 <- function(input_path, path) {
  reconstruct(train = paste0(input_path, "test3.txt"), output = paste0(path, "test3_re.txt"))
  line(train = paste0(path, "test3_re.txt"), output = paste0(path, "test_3_1st_wo_norm.txt")) #./test_cases/ref_outputs/
  line(train = paste0(path, "test3_re.txt"), output = paste0(path, "test_3_2nd_wo_norm.txt")) #./test_cases/ref_outputs/
  normalize(train = paste0(path, "test_3_1st_wo_norm.txt"), output = paste0(path, "test_3_1st.txt"), binary = 0)
  normalize(train = paste0(path, "test_3_2nd_wo_norm.txt"), output = paste0(path, "test_3_2nd.txt"), binary = 0)
  concatenate(input1 = paste0(path, "test_3_1st.txt"), input2 = paste0(path, "test_3_2nd.txt"), output = "../test_cases/ref_outputs/test_3_all.txt", binary = 0)
}

test_4 <- function(input_path, path) {
  reconstruct(train = paste0(input_path, "test4.txt"), output = paste0(path, "test4_re.txt"))
  line(train = paste0(path, "test4_re.txt"), output = paste0(path, "test_4_1st_wo_norm.txt")) #./test_cases/ref_outputs/
  line(train = paste0(path, "test4_re.txt"), output = paste0(path, "test_4_2nd_wo_norm.txt")) #./test_cases/ref_outputs/
  normalize(train = paste0(path, "test_4_1st_wo_norm.txt"), output = paste0(path, "test_4_1st.txt"), binary = 0)
  normalize(train = paste0(path, "test_4_2nd_wo_norm.txt"), output = paste0(path, "test_4_2nd.txt"), binary = 0)
  concatenate(input1 = paste0(path, "test_4_1st.txt"), input2 = paste0(path, "test_4_2nd.txt"), output = "../test_cases/ref_outputs/test_4_all.txt", binary = 0)
}

test_5 <- function() {
  test_youtube_large(input_path = "../", path = "../test_cases/ref_outputs/")
}

test_youtube_large <- function(path = "./", input_path = "./") {
  reconstruct(train = paste0(input_path, "net_youtube.txt"), output = paste0(path, "net_youtube_dense.txt"), 2, 1000)
  line(train = paste0(path, "net_youtube_dense.txt"), output = paste0(path, "vec_1st_wo_norm.txt"), binary = 0, size = 128, order = 1, negative = 5, samples = 10000, threads = 40) #./test_cases/ref_outputs/
  line(train = paste0(path, "net_youtube_dense.txt"), output = paste0(path, "vec_2nd_wo_norm.txt"), binary = 0, size = 128, order = 2, negative = 5, samples = 10000, threads = 40) #./test_cases/ref_outputs/
  normalize(train = paste0(path, "vec_1st_wo_norm.txt"), output = paste0(path, "vec_1st.txt"), binary = 0)
  normalize(train = paste0(path, "vec_2nd_wo_norm.txt"), output = paste0(path, "vec_2nd.txt"), binary = 0)
  concatenate(input1 = paste0(path, "vec_1st.txt"), input2 = paste0(path, "vec_2nd.txt"), output = "../test_cases/ref_outputs/vec_all.txt", binary = 0)
}

test <- function() {
  test_1(path = "../test_cases/ref_outputs/", input_path = "../test_cases/cases/")
  test_2(path = "../test_cases/ref_outputs/", input_path = "../test_cases/cases/")
  test_3(path = "../test_cases/ref_outputs/", input_path = "../test_cases/cases/")
  test_4(path = "../test_cases/ref_outputs/", input_path = "../test_cases/cases/")
  test_5()
}


#compile(dir = "../")
test()


