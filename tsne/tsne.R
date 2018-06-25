library("Matrix")
library("rsvd")
library("Rtsne")

fast_pca <- function(data, k){
    data_scaled <- scale(data, center = TRUE, scale = FALSE)
    out <- rsvd::rsvd(data_scaled, k = k)
    result <- data_scaled %*% out$v
    return(result)
}

input_dir = "inputs/"
output_dir = "plots/"
data <- readMM(paste(input_dir, "matrix.mtx", sep = ""))
row_table <- read.table(paste(input_dir, "genes.tsv", sep = ""))
row_names <- row_table[, 1]
col_table <- read.table(paste(input_dir, "barcodes.tsv", sep = ""))
col_names <- col_table[, 1]
rownames(data) <- row_names
colnames(data) <- col_names

data <- t(t(data)/colSums(data))
data <- data * 10000
data <- log2(data + 1)
genes_to_keep <- rowSums(data > 0) >= 20
data <- data[genes_to_keep, ]
data <- t(data)
pca_data <- fast_pca(data, 30)
rtsne_results <- Rtsne(X = pca_data, dims = 2, pca = FALSE)
rtsne_data <- rtsne_results$Y
x <- rtsne_data[, 1]
y <- rtsne_data[, 2]
pdf(paste(output_dir, "tsne_graph.pdf", sep = ""))
plot(x, y)

library(ggplot2)
ggplot() + aes(x=rtsne_data[, 1],
               y=rtsne_data[, 2],
               color=data[, 'ENSG00000170458']) +
           geom_point()
