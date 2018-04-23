#!/usr/bin/Rscript

devtools::load_all() # This assumes that we are running in the folder where caller.R is saved
library(optparse)

main <- function() {
  set.seed(1)
  option_list <- list(
    make_option(c("-c", "--command"), type = "character", default = NULL, 
		help = "enter command among line, reconstruct, normalize, or concatenate"),  
    make_option(c("-i", "--input_file"), type = "character", default = NULL, 
                help = "input file destination", metavar = "character"),
    make_option(c("-o", "--output_file"), type = "character", default = NULL, 
                help = "output file destination [default= %default]", metavar = "character"),
    make_option(c("-d", "--max_depth"), type = "integer", default = 1, 
                help = "max_depth parameter", metavar = "number"),
    make_option(c("-k", "--max_k"), type = "integer", default = 0, 
                help = "max_k parameter", metavar = "number"),
    make_option(c("-b", "--binary"), type = "integer", default = 0, 
                help = "binary format 0 or 1 (no or yes)", metavar = "number"),
    make_option(c("-di", "--dim"), type = "integer", default = 5, 
                help = "dimensions", metavar = "number"),
    make_option(c("-or", "--order"), type = "integer", default = 2, 
                help = "order 1 or 2 in line", metavar = "number"),
    make_option(c("-n", "--negative"), type = "integer", default = 5, 
                help = "number of negative samples", metavar = "number"),
    make_option(c("-s", "--samples"), type = "integer", default = 1, 
                help = "number of total samples in million", metavar = "number"),
    make_option(c("-r", "--rho"), type = "numeric", default = 0.025, 
                help = "rho value in line", metavar = NULL),
    make_option(c("-t", "--threads"), type = "integer", default = 1, 
                help = "number of threads used in line", metavar = "number"),
    make_option(c("-i1", "--input_file_1"), type = "character", default = NULL, 
                help = "input file1 destination", metavar = "character"),
    make_option(c("-i2", "--input_file_2"), type = "character", default = NULL, 
                help = "input file2 destination", metavar = "character")
  ); 
  
  opt_parser <- OptionParser(option_list = option_list);
  options <- parse_args(opt_parser);

  if (is.null(options$command)) {
      stop("Please enter a command")
  } else if (is.null(options$input_file) && is.null(options$input_file_1)) {
      stop("Please enter an input_file to read data from")
  } else if (options$command ==  "reconstruct") {
    if (options$max_depth <= 0) {
      stop("Please enter a positive max_depth or else reconstruct won't work")
    }
    input_df <- read.table(options$input_file)
    reconstruct_df <- reconstruct(df = input_df, max_depth = options$max_depth, max_k = options$max_k)
    fout <- file(options$output_file, "w")
    for(j in 1:nrow(reconstruct_df)) {
      cat(sprintf("%s\t%s\t%f", reconstruct_df[j, 1], reconstruct_df[j, 2], reconstruct_df[j, 3]), file = fout, sep = '\n')
    }
    close(fout)
  } else if (options$command == "line") {
    input_df <- read.table(options$input_file)
    line_matrix <- line(df = input_df, binary = options$binary, dim = options$dim, order = options$order, negative = options$negative, samples = options$samples, rho = options$rho, threads = options$threads)
    feature_names <- row.names(line_matrix)
    cat(sprintf("Binary: %d\nDimensions %d\nOrder %d\nNegative %d\nSamples %d\nRho %f\nThreads %d\n", 	    options$binary, options$dim, options$order, options$negative, options$samples, options$rho, options$threads))
    print(input_df)
     
    fout <- file(options$output_file, "w")
    cat(sprintf("%d %d\n", nrow(line_matrix), ncol(line_matrix)), file = fout)
    for(j in 1:nrow(line_matrix)) {
      cat(sprintf("%s ", feature_names[j]), file = fout)
      for (k in 1:ncol(line_matrix)) {
        cat(sprintf("%f ", line_matrix[j, k]), file = fout)
      }
      cat(sprintf("\n"), file = fout)
    }
    close(fout)
  } else if (options$command == "concatenate") {
    if (is.null(options$input_file_1) || is.null(options$input_file_2)) {
      stop("Please enter both an input_file_1 and input_file_2 to concatenate your files")
    }
    input_df_one <- read.table(options$input_file_1, skip = 1)
    input_df_two <- read.table(options$input_file_2, skip = 1)
    rownames(input_df_one) <- input_df_one[, 1]
    rownames(input_df_two) <- input_df_two[, 1]
    input_matrix_one = as.matrix(input_df_one[2:ncol(input_df_one)])
    input_matrix_two = as.matrix(input_df_two[2:ncol(input_df_two)])  
    concatenate_matrix <- concatenate(input_one = input_matrix_one, input_two = input_matrix_two, binary = options$binary)
    feature_names <- row.names(concatenate_matrix)    

    fout <- file(options$output_file, "w")
    cat(sprintf("%d %d\n", nrow(concatenate_matrix), ncol(concatenate_matrix)), file = fout)
    for(j in 1:nrow(concatenate_matrix)) {
      cat(sprintf("%s ", feature_names[j]), file = fout)
      for (k in 1:ncol(concatenate_matrix)) {
        cat(sprintf("%f ", concatenate_matrix[j, k]), file = fout)
      }
      cat(sprintf("\n"), file = fout)
    }
    close(fout)
  } else if (options$command == "normalize") {
    input_df <- read.table(options$input_file, skip = 1)
    rownames(input_df) <- input_df[, 1]
    input_matrix <- as.matrix(input_df[2:ncol(input_df)])
    normalize_matrix <- normalize(input_matrix)
    feature_names <- row.names(normalize_matrix)

    fout <- file(options$output_file, "w")
    cat(sprintf("%d %d\n", nrow(normalize_matrix), ncol(normalize_matrix)), file = fout)
    for(j in 1:nrow(normalize_matrix)) {
      cat(sprintf("%s ", feature_names[j]), file = fout)
      for (k in 1:ncol(normalize_matrix)) {
        cat(sprintf("%f ", normalize_matrix[j, k]), file = fout)
      }
      cat(sprintf("\n"), file = fout)
    }
    close(fout)
  } else {
    stop("Please enter a valid command. Your command choices include reconstruct, line, and concatenate")
  }
}

main()

