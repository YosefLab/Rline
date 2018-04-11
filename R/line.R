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

concatenate <- function(input_one, input_two, binary = 0) {
	lst <- concatenate_caller(input_one, input_two, binary)
	concatenate_df <- data.frame(matrix(ncol = length(lst), nrow = length(lst[[1]])))
	for (j in 1:length(lst)) {
	  concatenate_df[, j] = lst[[j]]
	}
	return(concatenate_df)
}


normalize <- function(df) {
  for (i in 1:nrow(df)) {
    len = 0.0
    for (j in 2:ncol(df)) {
      len = len + (df[i, j] * df[i, j])
    }
    len = sqrt(len)
    for (j in 2:ncol(df)) {
       df[i, j] = df[i, j] / len
    }
  }
  return(df);
}
