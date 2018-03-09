#!/usr/bin/Rscript
library(Rcpp)
library(RcppArmadillo)

# sourceCpp("Rreconstruct.cpp")
# test <- function(input_file_path) {
#   df = read.table(input_file_path)
#   df[, 1] = as.character(df[, 1])
#   df[, 2] = sapply(df[, 2], as.character)
#   result = reconstruct_caller(df[, 1], df[, 2], df[, 3])
#   return(df)
# }

sourceCpp("Rreconstruct2.cpp")
reconstruct <- function(input_file_path) {
  df = read.table(input_file_path)
  df[, 1] = as.character(df[, 1])
  df[, 2] = sapply(df[, 2], as.character)
  result = reconstruct_caller(df[, 1], df[, 2], df[, 3])
  return(result)
}

main <- function() {
    cwd <- "~/Desktop/Research/Line/Rline"
    path <- "./test_cases/cases/test"
    setwd(cwd)
    for (i in 1:4) {
      df = reconstruct(sprintf("%s%d.txt", path, i))
      file = sprintf("result%d.txt", i)
      for(i in 1:nrow(df)) {
        cat(sprintf("%s\t%s\t%f", df[i, 1], df[i, 2], df[i, 3]), file = file, append = TRUE, sep = '\n')
      }
    }
}

main()

