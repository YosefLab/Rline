#!/usr/bin/Rscript
library(Rcpp)
library(RcppArmadillo)

sourceCpp("Rreconstruct.cpp")
test <- function(input_file_path) {
  print(input_file_path)
  df = read.table(input_file_path)
  df[, 1] = as.character(df[, 1])
  df[, 2] = sapply(df[, 2], as.character)
  result = rmain(df)
  return(result)
}

main <- function() {
    path <- "test_cases/cases/test"
    for (i in 1:3) {
      df = test(sprintf("%s%d.txt", path, i))
    }
    print(df)
}

main()

