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
   print(expected_matrix); print(line_matrix);
   
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
   
   print(line_matrix); print(expected_matrix)  
   expect_equal(line_matrix, expected_matrix, tolerance = 1e-5, scale = 1)

})
