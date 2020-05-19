library(shiny)
library(ggplot2)
library(stringr)
library(ggplot2)
setwd("/home/zuhaib/Desktop/covid19Research/hackSeqRNA/theApp/data_GSE148729_Calu3_totalRNA/")

# data <- read.table("../GSE148729_Calu3_totalRNA_readcounts.txt", header = T, sep = "\t")

fls <- list.files()[grep("long_", list.files())]
datasets <- lapply(fls, function(x) {
  read.table(x, header = T, sep = "\t")
})
names(datasets) <- fls
names(datasets) <- str_replace_all(names(datasets), "\\.txt", "")
names(datasets) <- str_replace_all(names(datasets), "long_", "")



# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Miles Per Gallon"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    checkboxGroupInput("selDatasets", "Select Datasets", choices = names(datasets)),
    textAreaInput("selGenes", "Genes of Interest", height = "200px"),
    submitButton("Submit")
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    uiOutput("Plots")
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  ########## FUNCTIONS ##########
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
  ########## FUNCTIONS ##########
  
  # Based on the user-selected genes and datasets, creates a line for each gene in each dataset
  # Returns the line for each gene in each dataset (lns), also returns the max and min x and y values (useful for defining plot dimentions)
  # as well as the name of the datset (Name)
  dataToPlot <- reactive({
    return(lapply(input$selDatasets, function(y) {
      ds <- datasets[[y]]
      lst <- lapply(strsplit(input$selGenes, split = '[\r\n]')[[1]], function(x) {
        return(ds[grep(x, ds[,1]),])
      })
      lns <- lapply(lst, function(x) {
        return(makeLine(x))
      })
      xMax <- max(unlist(lapply(lns, function(x) return(x[,1])))) + 1
      yMin <- min(unlist(lapply(lns, function(x) return(x[,2])))) - 1
      yMax <- max(unlist(lapply(lns, function(x) return(x[,2])))) + length(lns)
      return(list(Plot = lns, xMax = xMax, yMin = yMin, yMax = yMax, Name = y))
    }))
  })
  
  # Defines the plotting windows based on the max and min x and y values for all plots
  # This is so the plot scales are consistent.
  plotWindow <- reactive({
    maxX <- max(unlist(lapply(dataToPlot(), function(x) return(x$xMax))))
    minY <- min(unlist(lapply(dataToPlot(), function(x) return(x$yMin))))
    maxY <- max(unlist(lapply(dataToPlot(), function(x) return(x$yMax))))
    return(list(right = maxX, left = -9, top = maxY, bottom = minY))
  })

  # Renders the plots. One plot for each selected dataset. The plot scales based on the max and min y-values
  output$Plots <- renderUI({
      lapply(dataToPlot(), function(d) {
        vShift <- 0
        renderPlot({
          plot(1, type="n", xlab="Time (h)", ylab="", xlim=c(plotWindow()$left, plotWindow()$right), ylim=c(plotWindow()$bottom, plotWindow()$top), main = d$Name)
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
        }, height = (plotWindow()$top - plotWindow()$bottom) * (3100/(plotWindow()$top - plotWindow()$bottom) + 800) / 35)
      })
  })
}

shinyApp(ui, server)