library(ggplot2)
library(stringr)
library(ggplot2)
setwd("/home/zuhaib/Desktop/covid19Research/rnaSeqData/GSE148729/dataFiles/GSE148729_Calu3_totalRNA/dataLongFormat")

data <- read.table("../GSE148729_Calu3_totalRNA_readcounts.txt", header = T, sep = "\t")

fls <- list.files()[grep("GSE", list.files())]
datasets <- lapply(fls, function(x) {
  read.table(x, header = T, sep = " ")
})
names(datasets) <- fls
names(datasets) <- str_replace_all(names(datasets), "\\.txt", "")



# Takes in the DE between time points of some gene, and returns x,y coordinates for the line
# as well as the color of the points based on whether it was significantly expressed.
# Note: Time points must be sorted
makeLine <- function(timePoints) {
  minTimePoint <- timePoints[1,2]
  retDF <- data.frame(x = c(minTimePoint, timePoints$T2),
                      y = c(0, cumsum(timePoints$log2FoldChange)),
                      sig = c("Significant", timePoints$Colour),
                      gene = timePoints[1,1])
  return(retDF)
}

makePlot <- function(goi, doi) {
  dataToPlot <- lapply(doi, function(y) {
    ds <- datasets[[y]]
    lst <- lapply(goi, function(x) {
      return(ds[grep(x, ds[,1]),])
    })
    lns <- lapply(lst, function(x) {
      return(makeLine(x))
    })
    

    xMax <- max(unlist(lapply(lns, function(x) return(x[,1])))) + 1
    yMin <- min(unlist(lapply(lns, function(x) return(x[,2])))) - 1
    yMax <- max(unlist(lapply(lns, function(x) return(x[,2])))) + length(lns)
    

    return(list(Plot = lns, xMax = xMax, yMin = yMin, yMax = yMax, Name = y))
  })

  maxX <- max(unlist(lapply(dataToPlot, function(x) return(x$xMax))))
  minY <- min(unlist(lapply(dataToPlot, function(x) return(x$yMin))))
  maxY <- max(unlist(lapply(dataToPlot, function(x) return(x$yMax))))
  

  # pointShift <- (maxY - minY) / length(goi)
  # maxY <- maxY + 2
  # print(maxY)
  
  for (d in dataToPlot) {
    vShift <- 0
    plot(1, type="n", xlab="Time (h)", ylab="", xlim=c(-9, maxX), ylim=c(minY, maxY), main = d$Name)
    for (i in d$Plot) {
      lines(i$x, 
            i$y + vShift, 
            type = "b", 
            col = sapply(i$sig, function(x) if (x == "Significant") return("black") else return("yellow")), 
            cex = 2, 
            pch = 16)
      text(-5, vShift, labels = i$gene)
      vShift <- vShift + 1
    }
  }
}


























# Old Code
# makePlot <- function(goi, doi) {
#   lst <- lapply(goi, function(x) {
#     return(datasets$GSE148729_Calu3_sarsCov2[grep(x, datasets$GSE148729_Calu3_sarsCov2[,1]),])
#   })
#   lns <- lapply(lst, function(x) {
#     return(makeLine(x))
#   })
#   xMax <- max(unlist(lapply(lns, function(x) return(x[,1])))) + 1
#   yMin <- min(unlist(lapply(lns, function(x) return(x[,2])))) - 1
#   yMax <- max(unlist(lapply(lns, function(x) return(x[,2])))) + length(lns)
#   vShift <- 0
#   plot(1, type="n", xlab="", ylab="", xlim=c(-5, xMax), ylim=c(yMin, yMax))
#   # rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = 
#   #        "antiquewhite")
#   for (i in lns) {
#     lines(i$x, 
#           i$y + vShift, 
#           type = "b", 
#           col = sapply(i$sig, function(x) if (x == "Significant") return("black") else return("yellow")), 
#           cex = 2, 
#           pch = 16)
#     text(-1, vShift, labels = i$gene)
#     vShift <- vShift + 1
#   }
# }
