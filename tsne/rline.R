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
	line_one_matrix <- line(reconstruct_df, dim = 10, order = 1, negative = neg, samples = samples, rho = rho)
	tsne_results <- Rtsne(X = line_one_matrix, dims = 2, pca = FALSE)
    tsne_matrix <- tsne_results$Y
    graph("line_one", tsne_matrix)
	line_two_matrix <- line(reconstruct_df, dim = 10, order = 2, negative = neg, samples = samples, rho = rho)
	tsne_results <- Rtsne(X = line_two_matrix, dims = 2, pca = FALSE)
    tsne_matrix <- tsne_results$Y
    graph("line_two", tsne_matrix)
	
	line_one_matrix <- line(reconstruct_df, dim = 5, order = 1, negative = neg, samples = samples, rho = rho)
	line_two_matrix <- line(reconstruct_df, dim = 5, order = 2, negative = neg, samples = samples, rho = rho)
	concatenate_matrix <- concatenate(line_one_matrix, line_two_matrix)
	normalize_matrix <- normalize(concatenate_matrix)
    tsne_results <- Rtsne(X = normalize_matrix, dims = 2, pca = FALSE)
	tsne_matrix <- tsne_results$Y
    graph("concatenate", tsne_matrix)		
}

graph <- function(name, input_matrix) {
	output_dir = "plots/"
	plot <- ggplot() + aes(x  = input_matrix[, 1], y = input_matrix[, 2]) + geom_point() + labs(x = "x", y = "y")
    ggsave(filename = paste(name, "scatter_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 100)
	plot <- ggplot() + aes(x = input_matrix[, 1], y = input_matrix[, 2]) + geom_density2d() + labs(x = "x", y = "y")
	ggsave(filename = paste(name, "probability_density_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 600)
}

input_dir = "inputs/"
edge_list <- read.table(paste(input_dir, "10.in", sep = ""))
rline(edge_list, depth = 2, max_k = 100, neg = 5, samples = 30, rho = 0.025, name = "10")



