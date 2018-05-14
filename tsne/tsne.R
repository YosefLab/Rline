library("Matrix")
library("rsvd")
library("Rtsne")

fast_pca <- function(data, k){
    data_scaled <- scale(data, center = TRUE, scale = FALSE)
    out <- rsvd::rsvd(data_scaled, k = 5)
    result <- data_scaled %*% out$v
    return(result)
}

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
rtsne_results <- Rtsne(X = pca_data, dims = 2, pca = FALSE)
rtsne_data <- rtsne_results$Y
x <- rtsne_data[,1]
y <- rtsne_data[,2]
plot(x, y)

