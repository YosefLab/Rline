library(RANN)
library(matrixStats)
library(Matrix)
library(rsvd)
library(devtools)
library(ggplot2)
library(Rtsne)
devtools::load_all()

graph <- function(name, input_matrix) {
	output_dir = "plots/"
	plot <- ggplot() + aes(x  = input_matrix[, 1], y = input_matrix[, 2]) + geom_point() + labs(x = "x", y = "y")
    ggsave(filename = paste(name, "scatter_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 100)
	plot <- ggplot() + aes(x = input_matrix[, 1], y = input_matrix[, 2]) + geom_density2d() + labs(x = "x", y = "y")
	ggsave(filename = paste(name, "probability_density_plot.pdf", sep = "_"), device = "pdf", plot = plot, path = output_dir, dpi = 600)
}


input_df <- read.table("./outputs/p2p_deepwalk_2_small.txt", colClasses = c("NULL", NA, NA), skip = 1)
graph("deep_walk_2", input_df)

input_df <- read.table("./outputs/p2p_deepwalk_8_small.txt", skip = 1)
input_df <- input_df[, 2:ncol(input_df)]
rtsne_results <- Rtsne(X = input_df, pca = FALSE, dims = 2)
rtsne_matrix <- as.matrix(rtsne_results$Y)
graph("deep_walk_8", rtsne_matrix)







