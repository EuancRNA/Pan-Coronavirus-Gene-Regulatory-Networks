library(DESeq2)
library(ggplot2)
library(stringr)
library(factoextra)
setwd("/home/zuhaib/Desktop/covid19Research/rnaSeqData/GSE148729/dataFiles/GSE148729_Calu3_totalRNA")

# Load data and convert it to a numeric matrix
data <- read.table("GSE148729_Calu3_totalRNA_readcounts.txt", header = T, sep = "\t")
row.names(data) <- data[,1]
data <- data[,-1]
data <- as.matrix(data)
data <- data[which(rowSums(data) > 0),]
mode(data) <- "integer"

# Extract metadata from the column names
listMeta <- strsplit(colnames(data), "\\.")
meta <- data.frame(Sample = colnames(data),
                   Cell = sapply(listMeta, function(x) return(x[1])),
                   Infection = sapply(listMeta, function(x) return(x[2])),
                   Time = sapply(listMeta, function(x) return(x[3])),
                   Replicate = sapply(listMeta, function(x) return(x[4])))
row.names(meta) <- meta[,1]
meta <- meta[,-1]
#write.table(meta, "meta.txt", sep = "\t", row.names = T, col.names = T, quote = F)

##### EXPLORATORY ANALYSIS ON DATA #####
# PCA before normalization
preNormalizePCA <- prcomp(t(data))
autoplot(preNormalizePCA, data = meta, colour = "Replicate", size = "Time", shape = "Infection")
# PCA after normalization
dataVST <- varianceStabilizingTransformation(data)
postNormalizePCA <- prcomp(t(dataVST))
autoplot(postNormalizePCA, data = meta, colour = "Replicate", size = "Time", shape = "Infection")

##### COMPARISON OF S1 4H TO 12H #####
##  DE S1 4H VS 12H ##
# Select the approppriate data
data1 <- data[,1:4]
meta1 <- meta[1:4,]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Time)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res1 <- res
ggplot(res1, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res1, "s1-4h-s1-12h.txt", row.names = T, col.names = T, sep = "\t", quote = F)

##  DE S1 12H VS 24H ##
# Select the approppriate data
data1 <- data[,3:6]
meta1 <- meta[3:6,]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Time)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res2 <- res
ggplot(res2, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res2, "s1-12h-s1-24h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S2 4H VS 12H ##
# Select the approppriate data
data1 <- data[,7:10]
meta1 <- meta[7:10,]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Time)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res3 <- res
ggplot(res3, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res3, "s2-4h-s2-12h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S2 12H VS 24H ##
# Select the approppriate data
data1 <- data[,9:12]
meta1 <- meta[9:12,]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Time)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res4 <- res
ggplot(res4, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res4, "s2-12h-s2-24h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S1 4H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(1,2,17,18)]
meta1 <- meta[c(1,2,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res5 <- res
ggplot(res5, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res5, "s1-4h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S1 12H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(3,4,17,18)]
meta1 <- meta[c(3,4,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res6 <- res
ggplot(res6, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res6, "s1-12h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S1 24H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(5,6,17,18)]
meta1 <- meta[c(5,6,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res7 <- res
ggplot(res7, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res7, "s1-24h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S2 4H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(7,8,17,18)]
meta1 <- meta[c(7,8,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res8 <- res
ggplot(res8, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res8, "s2-4h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S2 12H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(9,10,17,18)]
meta1 <- meta[c(9,10,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res9 <- res
ggplot(res9, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res9, "s2-12h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE S2 24H VS UNTR ##
# Select the approppriate data
data1 <- data[,c(11,12,17,18)]
meta1 <- meta[c(11,12,17,18),]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Infection)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res10 <- res
ggplot(res10, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res10, "s2-24h-unt-4h.txt", row.names = T, col.names = T, sep = "\t", quote = F)


##  DE MOCK 4H VS 12H ##
# Select the approppriate data
data1 <- data[,13:16]
meta1 <- meta[13:16,]
# DE analysis
obj <- DESeqDataSetFromMatrix(countData = data1, colData = meta1, design = ~ Time)
obj <- DESeq(obj)
res <- results(obj)
res <- res[which(!is.na(res$padj)),]
res <- as.data.frame(res)
res <- res[order(res$log2FoldChange, decreasing = T),]
res$Colour <- sapply(res$padj, function(x) if (x <= 0.05) return("Significant") else return("Not"))
res11 <- res
ggplot(res11, aes(x = log2FoldChange, y = -log(padj))) + geom_point(aes(color = Colour)) + xlim(-14, 8) + ylim(0, 50)
write.table(res11, "mock-4h-mock-12h.txt", row.names = T, col.names = T, sep = "\t", quote = F)
