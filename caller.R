#!/usr/bin/Rscript
library(Rcpp)
library(RcppArmadillo)
library("optparse")

sourceCpp("caller.cpp")
reconstruct <- function(df, max_depth = 1, max_k = 0) {
  return(reconstruct_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), max_depth, max_k))
}

line <- function(df, binary = 0, dim = 100, order = 2, negative = 5, samples = 1, rho = 0.025, threads = 1) {
  return(line_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), binary, dim, order, negative, samples, rho, threads))
}

normalize <- function(df) {
  normalize_caller()
}

concatenate <- function(df) {
  concatenate_caller()
}

#Rscript caller.R --command reconstruct --input_file ./test_cases/cases/test$i.txt --output_file ./test_cases/r_outputs/reconstruct$i.txt  --max_depth $max_depth --max_k $max_k
main <- function() {
  option_list = list(
    make_option(c("-c", "--command"), type="character", default=NULL, 
                help="command to execute reconstruct, line, concatenate, or normalize", metavar="character"),
    make_option(c("-i", "--input_file"), type="character", default=NULL, 
                help="input file destination", metavar="character"),
    make_option(c("-o", "--output_file"), type="character", default="result.txt", 
                help="output file destination [default= %default]", metavar="character"),
    make_option(c("-d", "--max_depth"), type="integer", default=1, 
                help="max_depth parameter", metavar="number"),
    make_option(c("-k", "--max_k"), type="integer", default=0, 
                help="max_k parameter", metavar="number"),
    make_option(c("-b", "--binary"), type="integer", default=0, 
                help ="binary format?", metavar="number"),
    make_option(c("-di", "--dim"), type="integer", default=100, 
                help ="dimensions", metavar="number"),
    make_option(c("-or", "--order"), type="integer", default=2, 
                help ="order 1 or 2 in line", metavar="number"),
    make_option(c("-n", "--negative"), type="integer", default=5, 
                help ="number of negative samples", metavar="number"),
    make_option(c("-s", "--samples"), type="integer", default=1, 
                help ="number of total samples in million", metavar="number"),
    make_option(c("-r", "--rho"), type="numeric", default=0.025, 
                help ="rho value in line", metavar=NULL),
       make_option(c("-t", "--threads"), type="integer", default=1, 
                help ="number of threads used in line", metavar="number"),
  ); 
  opt_parser = OptionParser(option_list = option_list);
  options = parse_args(opt_parser);
  if (is.null(options$command)) {
      stop("Please enter a command")
  } else if (is.null(options$input_file)) {
      stop("Please enter an input_file to read data from")
  } else if (options$command ==  "reconstruct") {
    if (options$max_depth <= 0) {
      stop("Please enter a positive max_depth or else reconstruct won't work")
    }
    input_df = read.table(options$input_file)
    if (ncol(input_df) == 2) {
	    input_df$new_column <- rep(1, nrow(input_df))
    }
    reconstruct_df = reconstruct(input_df, options$max_depth, options$max_k)
    fout <- file(options$output_file, "w")
    for(j in 1:nrow(reconstruct_df)) {
      cat(sprintf("%s\t%s\t%f", reconstruct_df[j, 1], reconstruct_df[j, 2], reconstruct_df[j, 3]), file = fout, sep = '\n')
    }
    close(fout)
  } else if (options$command == "line") {
    input_df = read.table(options$input_file)
    line_df = line_df(input_df, options$binary, options$dim, options$order, options$negative, options$samples, options$rho, options$threads)
    fout <- file(options$output_file, "w")
    for(j in 1:nrow(reconstruct_df)) {
      cat(sprintf("%s ", reconstruct_df[j, 1]), file = fout)
      for (k in 2:ncol(reconstruct_df)) {
        cat(sprintf("%lf "), reconstruct_df[j, k], file = fout)
      }
      cat(sprintf("\n"), file = fout)
    }
    close(fout)
  } else if (options$command == "normalize") {
    warning("Not implemented yet")
  } else if (options$command == "concatenate") {
    warning("Not implemented yet")
  } else {
    stop("Please enter a valid command. Your command choices include reconstruct, line, concatenate, and normalize")
  }
}

main()

