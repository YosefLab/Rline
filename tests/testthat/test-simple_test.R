context("test-simple_test.R")

test_that("simple reconstruct works", {
   input_file <- "../test_data/input_1.txt"
   output_file <- "../test_data/reconstruct_1.txt"
   input_df <- read.table(input_file)
   reconstruct_df <- reconstruct(df = input_df)
   expected_df <- read.table(output_file)
   colnames(reconstruct_df) <- NULL #edge case to remove colnames
   colnames(expected_df) <- NULL    #edge case to remove colnames

   expect_equal(reconstruct_df, expected_df, tolerance = 1e-5, scale = 1)
})

test_that("simple line works", {
   input_file <- "../test_data/reconstruct_1.txt"
   output_file <- "../test_data/line_1_1.txt"
   input_df <- read.table(input_file)
   line_matrix <- line(df = input_df, binary = 0, dim = 5, order = 1)
   output_df <- read.table(output_file, skip = 1)
   expected_matrix <- as.matrix(output_df[2:length(output_df)])
   rownames(expected_matrix) <- output_df[, 1]
   colnames(line_matrix) <- NULL 
   colnames(expected_matrix) <- NULL
   
   expect_equal(line_matrix, expected_matrix, tolerance = 1e-5, scale = 1)
   
   input_file <- "../test_data/reconstruct_1.txt"
   output_file <- "../test_data/line_2_1.txt"
   input_df <- read.table(input_file)
   line_matrix <- line(df = input_df, binary = 0, dim = 5, order = 2)
   output_df <- read.table(output_file, skip = 1)
   expected_matrix <- as.matrix(output_df[2:length(output_df)])
   rownames(expected_matrix) <- output_df[, 1]
   colnames(line_matrix) <- NULL
   colnames(expected_matrix) <- NULL
   
   expect_equal(line_matrix, expected_matrix, tolerance = 1e-2, scale = 1)
})

test_that("simple concatenate works", {
   input_file_1 <- "../test_data/line_1_1.txt"
   input_file_2 <- "../test_data/line_2_1.txt"
   input_one_df <- read.table(input_file_1, skip = 1)
   input_two_df <- read.table(input_file_2, skip = 1)
   input_one  <- as.matrix(input_one_df[2:length(input_one_df)])
   input_two <- as.matrix(input_two_df[2:length(input_two_df)])
   rownames(input_one) <- input_one_df[, 1]
   rownames(input_two) <- input_two_df[, 1]
   concatenate_matrix <- concatenate(input_one = input_one, input_two = input_two)
   
   output_file <- "../test_data/concatenate_1.txt"
   output_df <- read.table(output_file, skip = 1)
   expected_matrix <- as.matrix(output_df[2:length(output_df)])
   rownames(expected_matrix) <- output_df[, 1]
   colnames(expected_matrix) <- colnames(concatenate_matrix) <- NULL  
   
   expect_equal(concatenate_matrix, expected_matrix, tolerance = 1e-2, scale = 1)
  
})


test_that("simple normalize works", {
  input_file <- "../test_data/concatenate_1.txt"
  input_df <- read.table(input_file, skip = 1)
  input_matrix <- as.matrix(input_df[2:length(input_df)])
  rownames(input_matrix) <- input_df[, 1]
  normalize_matrix <- normalize(input_matrix) 

  output_file <- "../test_data/normalize_1.txt"
  output_df <- read.table(output_file, skip = 1)
  expected_matrix <- as.matrix(output_df[2:length(output_df)])
  rownames(expected_matrix) <- output_df[, 1]
  colnames(expected_matrix) <- colnames(normalize_matrix) <- NULL  
    
  expect_equal(normalize_matrix, expected_matrix, tolerance = 1e-2, scale = 1)
})
