###########################################
# This script takes the data in long_ files and finds the least squares line for each gene in each sample
# The slopes of these lines can be sued to compares a gene across the three samples
###########################################



setwd("/home/zuhaib/Desktop/covid19Research/hackSeqRNA/theApp/data_GSE148729_Calu3_totalRNA")

mock <- read.table("long_GSE148729_Calu3_mockInfection.txt", sep = "\t", header = T)
cov1 <- read.table("long_GSE148729_Calu3_sarsCov1.txt", sep = "\t", header = T)
cov2 <- read.table("long_GSE148729_Calu3_sarsCov2.txt", sep = "\t", header = T)

genes <- unique(mock$Gene)

# Takes in the DE between time points of some gene, and returns x,y coordinates for the line
# as well as the color of the points based on whether it was significantly expressed.
# Note: Time points must be sorted
makeLine <- function(timePoints) {
  timePoints <- cov1[grep(sample(genes, 1), cov1$Gene),]
  minTimePoint <- timePoints[1,2]
  x <- c(minTimePoint, timePoints$T2)
  y <- c(0, cumsum(timePoints$log2FoldChange))
  theModel <- lm(y~x)
  return(c(slope = theModel$coefficients[[2]], yInt = theModel$coefficients[[1]]))
}

# Get lines for each gene in mock infection group
lr_mock <- lapply(genes, function(g) {
  timePoints <- mock[grep(g, mock$Gene),]
  minTimePoint <- timePoints[1,2]
  x <- c(minTimePoint, timePoints$T2)
  y <- c(0, cumsum(timePoints$log2FoldChange))
  theModel <- lm(y~x)
  return(c(slope = theModel$coefficients[[2]], yInt = theModel$coefficients[[1]]))
})
names(lr_mock) <- genes
colnames(lr_mock) <- c("mock_slope", "mock_yInt")
lr_mock <- do.call(rbind, lr_mock)

# Get lines for each gene in cov1 infection group
lr_cov1 <- lapply(genes, function(g) {
  timePoints <- cov1[grep(g, cov1$Gene),]
  minTimePoint <- timePoints[1,2]
  x <- c(minTimePoint, timePoints$T2)
  y <- c(0, cumsum(timePoints$log2FoldChange))
  theModel <- lm(y~x)
  return(c(cov1_slope = theModel$coefficients[[2]], cov1_yInt = theModel$coefficients[[1]]))
})
names(lr_cov1) <- genes
lr_cov1 <- do.call(rbind, lr_cov1)

# Get lines for each gene in cov2 infection group
lr_cov2 <- lapply(genes, function(g) {
  timePoints <- cov2[grep(g, cov2$Gene),]
  minTimePoint <- timePoints[1,2]
  x <- c(minTimePoint, timePoints$T2)
  y <- c(0, cumsum(timePoints$log2FoldChange))
  theModel <- lm(y~x)
  return(c(cov2_slope = theModel$coefficients[[2]], cov2_yInt = theModel$coefficients[[1]]))
})
names(lr_cov2) <- genes
lr_cov2 <- do.call(rbind, lr_cov2)

retDF <- cbind(lr_mock, lr_cov1, lr_cov2)

# Write to file
write.table(retDF, "leastSquaresLinesPerGenePerInfections.txt", col.names = T, row.names = T, quote = F, sep = "\t")

