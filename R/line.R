reconstruct <- function(df, max_depth = 1, max_k = 0) {
  return(reconstruct_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), max_depth, max_k))
}

line <- function(df = NULL, binary = 0, dim = 100, order = 2, negative = 5, samples = 1, rho = 0.025, threads = 1) {
  return(line_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), binary, dim, order, negative, samples, rho, threads))
}

concatenate <- function(input_one, input_two, binary = 0) {
  return(concatenate_caller(input_one, input_two, rownames(input_one), rownames(input_two), binary))
}

normalize <- function(input_matrix) {
  return(input_matrix / sqrt(rowSums(input_matrix * input_matrix)))
}
