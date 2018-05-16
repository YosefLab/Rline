library(RANN)
library(matrixStats)
library(Matrix)
library(rsvd)
library(devtools)
library(ggplot2)
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

graph <- function(name, input_matrix) {
	output_dir = "plots/"
	plot <- ggplot() + aes(x  = input_matrix[, 1], y = input_matrix[, 2]) + geom_point()
        ggsave(filename = paste(output_dir, paste(name, "scatter_plot.pdf", sep = "_"), sep = ""), plot = plot, dpi = 100) + labs(x = "x", y = "y")
	plot <- ggplot() + aes(x = input_matrix[, 1], y = input_matrix[, 2]) + geom_density2d()
	ggsave(filename = paste(output_dir, paste(name, "probability_density_plot.pdf", sep = "_"), sep = ""), plot = plot, dpi = 600) + labs(x = "x", y = "y")
}

input_dir = "inputs/"
edge_list <- read.table(paste(input_dir, "10.in", sep = ""))
rline(edge_list, depth = 2, max_k = 100, neg = 5, samples = 30, rho = 0.025, name = "10")



