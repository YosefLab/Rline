library("Matrix")

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
