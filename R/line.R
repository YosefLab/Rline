reconstruct <- function(df, max_depth = 1, max_k = 0) {
  return(reconstruct_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), max_depth, max_k))
}

line <- function(df = NULL, binary = 0, dim = 100, order = 2, negative = 5, samples = 1, rho = 0.025, threads = 1) {
  lst <- line_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), binary, dim, order, negative, samples, rho, threads)
  line_df <- data.frame(matrix(ncol = length(lst), nrow = length(lst[[1]])))
  for (j in 1:length(lst)) {
    line_df[, j] = lst[[j]]
  }
  return(line_df)
}


normalize <- function(df) {
  normalize_caller()
}

concatenate <- function(df) {
  concatenate_caller()
}

