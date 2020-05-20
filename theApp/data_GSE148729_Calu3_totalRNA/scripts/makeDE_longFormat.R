######################################
# This script will take in the DE files anc convert them into long format
# See README.md for details on the format
######################################
setwd("/home/zuhaib/Desktop/covid19Research/hackSeqRNA/theApp/data_GSE148729_Calu3_totalRNA/DE")

fls <- list.files()[grep("h", list.files())]
dfs <- lapply(fls, function(x) return(read.table(x, header = T, sep = "\t")[,c(2,7)]))
names(dfs) <- fls
dfs <- lapply(dfs, function(x) {
  z <- x
  z$Gene <- row.names(z)
  return(z)
})

data <- read.table("../GSE148729_Calu3_totalRNA_readcounts.txt", sep = "\t", header = T)
row.names(data) <- data[,1]
data <- data[,-1]

##### BUILDING THE S1 MATRIX #####
### 4H VS 12H DATA ###
s1.4h.s1.12h <- data.frame(Gene = row.names(data), T1 = 4, T2 = 12)
s1.4h.s1.12h <- merge(s1.4h.s1.12h, dfs$`s1-4h-s1-12h.txt`, all = T)
s1.4h.s1.12h$log2FoldChange <- (-1)*s1.4h.s1.12h$log2FoldChange      # Need to flip the fold change values so that the positive values in dicate higher expression in the later timepoint
# All genes not in the DE genes, are considered not differentially epxressed and are given a log2foldChange of 1
s1.4h.s1.12h$log2FoldChange[which(is.na(s1.4h.s1.12h$log2FoldChange))] <- 0
s1.4h.s1.12h$Colour[which(is.na(s1.4h.s1.12h$Colour))] <- "Not"

### 12H VS 24H DATA ###
s1.12h.s1.24h <- data.frame(Gene = row.names(data), T1 = 12, T2 = 24)
s1.12h.s1.24h <- merge(s1.12h.s1.24h, dfs$`s1-12h-s1-24h.txt`, all = T)
# All genes not in the DE genes, are considered not differentially epxressed and are given a log2foldChange of 1
s1.12h.s1.24h$log2FoldChange[which(is.na(s1.12h.s1.24h$log2FoldChange))] <- 0
s1.12h.s1.24h$Colour[which(is.na(s1.12h.s1.24h$Colour))] <- "Not"

# Putting thse two together
s1 <- rbind(s1.4h.s1.12h, s1.12h.s1.24h)

write.table(s1, "GSE148729_Calu3_sarsCov1.txt", row.names = F, col.names = T, quote = F, sep = "\t")

##### BUILDING THE s2 MATRIX #####
### 4H VS 12H DATA ###
s2.4h.s2.12h <- data.frame(Gene = row.names(data), T1 = 4, T2 = 12)
s2.4h.s2.12h <- merge(s2.4h.s2.12h, dfs$`s2-4h-s2-12h.txt`, all = T)
s2.4h.s2.12h$log2FoldChange <- (-1)*s2.4h.s2.12h$log2FoldChange      # Need to flip the fold change values so that the positive values in dicate higher expression in the later timepoint
# All genes not in the DE genes, are considered not differentially epxressed and are given a log2foldChange of 1
s2.4h.s2.12h$log2FoldChange[which(is.na(s2.4h.s2.12h$log2FoldChange))] <- 0
s2.4h.s2.12h$Colour[which(is.na(s2.4h.s2.12h$Colour))] <- "Not"

### 12H VS 24H DATA ###
s2.12h.s2.24h <- data.frame(Gene = row.names(data), T1 = 12, T2 = 24)
s2.12h.s2.24h <- merge(s2.12h.s2.24h, dfs$`s2-12h-s2-24h.txt`, all = T)
# All genes not in the DE genes, are considered not differentially epxressed and are given a log2foldChange of 1
s2.12h.s2.24h$log2FoldChange[which(is.na(s2.12h.s2.24h$log2FoldChange))] <- 0
s2.12h.s2.24h$Colour[which(is.na(s2.12h.s2.24h$Colour))] <- "Not"

# Putting thse two together
s2 <- rbind(s2.4h.s2.12h, s2.12h.s2.24h)

write.table(s2, "GSE148729_Calu3_sarsCov2.txt", row.names = F, col.names = T, quote = F, sep = "\t")


##### BUILDING THE MOCK MATRIX #####
### 4H VS 24h DATA ###
mock.4h.mock.24h <- data.frame(Gene = row.names(data), T1 = 4, T2 = 24)
mock.4h.mock.24h <- merge(mock.4h.mock.24h, dfs$`mock-4h-mock-12h.txt`, all = T)    # This file was named wrong. It should've been mock-4h-mock-14h.txt
mock.4h.mock.24h$log2FoldChange <- (-1)*mock.4h.mock.24h$log2FoldChange      # Need to flip the fold change values so that the positive values in dicate higher expression in the later timepoint
# All genes not in the DE genes, are considered not differentially epxressed and are given a log2foldChange of 1
mock.4h.mock.24h$log2FoldChange[which(is.na(mock.4h.mock.24h$log2FoldChange))] <- 0
mock.4h.mock.24h$Colour[which(is.na(mock.4h.mock.24h$Colour))] <- "Not"

write.table(mock.4h.mock.24h, "GSE148729_Calu3_mockInfection.txt", row.names = F, col.names = T, quote = F, sep = "\t")
