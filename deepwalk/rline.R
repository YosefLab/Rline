library(RANN)
library(matrixStats)
library(Matrix)
library(rsvd)
library(devtools)
library(ggplot2)
library(Rtsne)
devtools::load_all()

rline <- function(edge_list_df, depth = 2, max_k = 10, neg = 5, samples = 10, rho = 0.025, name = "50") {
	reconstruct_df <- reconstruct(edge_list_df, max_depth = depth, max_k = max_k)
	line_one_matrix <- line(reconstruct_df, dim = 2, order = 1, negative = neg, samples = samples, rho = rho)
	graph("line_one", line_one_matrix)
	line_two_matrix <- line(reconstruct_df, dim = 2, order = 2, negative = neg, samples = samples, rho = rho)
	graph("line_two", line_two_matrix)
	
	line_one_matrix <- line(reconstruct_df, dim = 1, order = 1, negative = neg, samples = samples, rho = rho)
	line_two_matrix <- line(reconstruct_df, dim = 1, order = 2, negative = neg, samples = samples, rho = rho)
	concatenate_matrix <- concatenate(line_one_matrix, line_two_matrix)
	normalize_matrix <- normalize(concatenate_matrix)
	graph("concatenate", normalize_matrix)		
}

tsne <- function(edge_list_df, depth = 2, max_k = 10, neg = 5, samples = 10, rho = 0.025, dim = 10, name = "50") {
	reconstruct_df <- reconstruct(edge_list_df, max_depth = depth, max_k = max_k)
	line_one_matrix <- line(reconstruct_df, dim = dim, order = 1, negative = neg, samples = samples, rho = rho)
    rtsne_results <- Rtsne(perplexity=10,X = line_one_matrix, pca = FALSE, dims = 2)
    rtsne_matrix <- as.matrix(rtsne_results$Y) 
	graph("tsne_line_one", rtsne_matrix)
	line_two_matrix <- line(reconstruct_df, dim = dim, order = 2, negative = neg, samples = samples, rho = rho)
	rtsne_results <- Rtsne(perplexity = 10,X = line_two_matrix, pca = FALSE, dims = 2)
    rtsne_matrix <- as.matrix(rtsne_results$Y)
    graph("tsne_line_two", rtsne_matrix)
	
	line_one_matrix <- line(reconstruct_df, dim = dim / 2, order = 1, negative = neg, samples = samples, rho = rho)
	line_two_matrix <- line(reconstruct_df, dim = dim / 2, order = 2, negative = neg, samples = samples, rho = rho)
	concatenate_matrix <- concatenate(line_one_matrix, line_two_matrix)
	normalize_matrix <- normalize(concatenate_matrix)
    rtsne_results <- Rtsne(perplexity = 10,X = normalize_matrix, pca = FALSE, dims = 2)
    rtsne_matrix <- as.matrix(rtsne_results$Y)
	graph("tsne_concatenate", rtsne_matrix)		
}

graph <- function(name, input_matrix) {
	output_dir = "plots/"
	plot <- ggplot() + aes(x  = input_matrix[, 1], y = input_matrix[, 2]) + geom_point() + labs(x = "x", y = "y")
    ggsave(filename = paste(name, "scatter_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 100)
	plot <- ggplot() + aes(x = input_matrix[, 1], y = input_matrix[, 2]) + geom_density2d() + labs(x = "x", y = "y")
	ggsave(filename = paste(name, "probability_density_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 600)
}

input_dir = "inputs/"
edge_list <- read.table(paste(input_dir, "p2p_weighted.txt", sep = ""))
rline(edge_list, depth = 2, max_k = 100, neg = 5, samples = 30, rho = 0.025, name = "line_30")
tsne(edge_list, depth = 2, max_k = 100, neg = 5, samples = 30, rho = 0.025, dim = 10, name = "line_30")





