#!/usr/bin/Rscript
library(Rcpp)
library(RcppArmadillo)
library("optparse")

sourceCpp("caller.cpp")
reconstruct <- function(df, max_depth = 1, max_k = 0) {
  return(reconstruct_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), max_depth, max_k))
}

line <- function(df) {
  line_caller()
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
                help="max_k parameter", metavar="number")
  ); 
  opt_parser = OptionParser(option_list = option_list);
  options = parse_args(opt_parser);
  if (is.null(options$command)) {
      stop("Please enter a command")
  } else if (options$command ==  "reconstruct") {
    if (is.null(options$input_file)) {
      stop("Please enter an input_file to read data from")
    } else if (options$max_depth <= 0) {
      stop("Please enter a positive max_depth or else reconstruct won't work")
    }
    input_df = read.table(options$input_file)
    if (ncol(input_df) == 2) {
	input_df$new_column <- rep(1, nrow(input_df))
    }
    #fout <- file(options$output_file, "w")
    #for(j in 1:nrow(input_df)) {
    #   cat(sprintf("%s %s %f", input_df[j, 1], input_df[j, 2], input_df[j, 3]), file = fout, sep = '\n') 
    #}
    #close(fout)
    reconstruct_df = reconstruct(input_df, options$max_depth, options$max_k)
    fout <- file(options$output_file, "w")
    for(j in 1:nrow(reconstruct_df)) {
      cat(sprintf("%s\t%s\t%f", reconstruct_df[j, 1], reconstruct_df[j, 2], reconstruct_df[j, 3]), file = fout, sep = '\n')
    }
    close(fout)
  } else if (options$command == "line") {
    warning("Not implemented yet")
  } else if (options$command == "normalize") {
    warning("Not implemented yet")
  } else if (options$command == "concatenate") {
    warning("Not implemented yet")
  } else {
    stop("Please enter a valid command. Your command choices include reconstruct, line, concatenate, and normalize")
  }
}

main()

