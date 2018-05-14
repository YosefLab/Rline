library(RANN)
library(matrixStats)
library(Matrix)
library(rsvd)

#' Compute weights for neighbors
#'
#' Given a matrix of distances, computes appropriate 'weights'
#' which decay according to a Guassian Kernel with width equal
#' to the distance to the N_NEIGHBORS / <neighborhood_factor> neighbor
#' @import Matrix
#' @import matrixStats
#' @param distances distances to neighbors.  matrix of dimension
#' N_CELLS x N_NEIGHBORS
#' @param neighborhood_factor What proportion of neighborhood to use to
#' define the gaussian kernel width. Default is 3
#' @export
#' @return weights weights for each neighbor.  Same size/type as distances
#' input
computeWeights <- function(distances, neighborhood_factor=3){
    # Compute weights
    radius_ii <- ceiling(ncol(distances) / neighborhood_factor)
    sigma <- distances[, radius_ii]
    weights <- exp(-1 * distances ** 2 / sigma ** 2)
    wnorm <- rowSums(weights)
    wnorm[wnorm == 0] <- 1.0
    weights <- weights / wnorm
    return(weights)
}

#' Find Nearest Neighbors and Asociated Weights
#'
#' Using the input data matrix, for each cell (row) compute the
#' nearest n_neighbors and compute a weight for each neighbor.
#'
#' @importFrom RANN nn2
#' @param data Matrix to use to derive distances. It's recommended to u
#' se a PCA-reduced gene expression matrix here.  matrix of dimension 
#' N_CELLS x N_COMPONENTS
#' @param n_neighbors How many neighbors to use for each cell
#' @param neighborhood_factor What proportion of neighborhood to use to
#' define the gaussian kernel width. Default is 3
#' @export
#' @return out$neighbors n_nearest neighbors for each cell.  Matrix of
#' size N_CELLS x N_Neighbors.  Entries represent index of neighbors
#' @return out$weights weights for each neighbor.  Same size/type as out$neighbors
#' input
neighborsAndWeights <- function(data, n_neighbors=30, neighborhood_factor=3){
    nbrs <- nn2(data = data, k = n_neighbors+1, treetype = "bd",
               searchtype = "standard")
    idx <- nbrs$nn.idx
    dists <- nbrs$nn.dists
    # Exclude self
    idx <- idx[, -1]
    dists <- dists[, -1]
    weights <- computeWeights(dists, neighborhood_factor)
    out <- list(neighbors=idx, weights=weights)
    return(out)
}

fast_pca <- function(data, k){
    data_scaled <- scale(data, center = TRUE, scale = FALSE)
    out <- rsvd::rsvd(data_scaled, k = 5)
    result <- data_scaled %*% out$v
    return(result)
}


create_edge_list <- function(adjacency_matrix, weights) {
	return(adjacency_matrix)	
}

#reading in data and preprocessing with pca
# Like with tSNE, scale the columns and log transform
data <- readMM("matrix.mtx")
row_table <- read.table("genes.tsv")
row_names <- as.vector(levels(row_table[,1]))
col_table <- read.table("barcodes.tsv")
col_names <- as.vector(levels(col_table[,1]))
rownames(data) <- row_names
colnames(data) <- col_names
data <- t(t(data)/colSums(data))
data <- data * 10000
data <- log2(data + 1)
genes_to_keep <- rowSums(data > 0) >= 20
data <- data[genes_to_keep, ]
data <- t(data)
pca_data <- fast_pca(data, 30)


# nearest neighbors 
# idx and weights are both N_CELLS by N_NEIGHBORS
# they describe a weighted graph
# e.g., row i in idx describes connections for element i
# An example: 
# if row 7 of idx is:
# [3, 10, 20, 5]
# and row 7 of weights is:
# [.5, .3, .02, .7]
#out <- neighborsAndWeights(data, n_neighbors = 30)
out <- neighborsAndWeights(pca_data, n_neighbors = 30)
idx <- out$idx
weights <- out$weights
print(head(idx))
print(head(weights))
print(dim(idx))
df <- create_edge_list(idx, weights)

#Rline
reconstruct_df <- reconstruct(df)
line_one <- line(reconstruct_df, dim = 2, order = 1)
line_two <- line(reconstruct_df, dim = 2, order = 2)
concatenate_matrix <- concatenate(line_one, line_two)
normalize_matrix <- normalize(concatenate_matrix)
print(dim(normalize_matrix))
x <- normalize_matrix[,1]
y <- normalize_matrix[,2]
plot(x, y)

# then the corresponding edges are:
# 7 -> 3, weight .5
# 7 -> 10, weight .3
# 7 -> 20, weight .02
# 7 -> 5, weight .7
