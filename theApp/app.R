library(shiny)
library(ggplot2)
library(stringr)
library(ggplot2)
setwd("/home/zuhaib/Desktop/covid19Research/hackSeqRNA/Pan-Coronavirus-Gene-Regulatory-Networks/theApp")

fls <- unlist(lapply(list.files()[grep("data_", list.files())], function(d) {
  path <- paste0("./", d, "/")
  filesInDir <- list.files(path)
  return(paste0(path, filesInDir[grep("long_", filesInDir)]))
}))
datasets <- lapply(fls, function(x) {
  read.table(x, header = T, sep = "\t")
})
names(datasets) <- fls
names(datasets) <- str_replace_all(names(datasets), "\\.txt", "")
names(datasets) <- str_replace_all(names(datasets), "\\..+long_", "")



# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Gene Expression Changes"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    checkboxGroupInput("selDatasets", "Select Datasets", choices = names(datasets)),
    textAreaInput("selGenes", "Genes of Interest", height = "200px"),
    radioButtons("collapseLines", label = "Collapse lines?",
                 choices = list("Yes" = "yes", "No" = "no"), 
                 selected = "no"),
    submitButton("Submit")
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    verbatimTextOutput("GNF"),
    uiOutput("Plots")
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  ########## FUNCTIONS ##########
  # Takes in the DE between time points of some gene, and returns x,y coordinates for the line
  # as well as the color of the points based on whether it was significantly expressed.
  # Note: Time points must be sorted
  makeLine <- function(timePoints, collapseLinesFlag = F) {
    minTimePoint <- timePoints[1,2]
    # If the lines will collapse, then raise each y value to the power of to so lines don't clump together
    if (collapseLinesFlag == T) {
      yVals <- 2^c(0, cumsum(timePoints$log2FoldChange))
    } else {
      yVals <- c(0, cumsum(timePoints$log2FoldChange))
    }
    retDF <- data.frame(x = c(minTimePoint, timePoints$T2),
                        y = yVals,
                        sig = c("Significant", timePoints$Colour),
                        gene = timePoints[1,1])
    return(retDF)
  }
  ########## FUNCTIONS ##########
  
  
  # Based on the user-selected genes and datasets, creates a line for each gene in each dataset
  # Returns the line for each gene in each dataset (lns), also returns the max and min x and y values (useful for defining plot dimentions)
  # as well as the name of the datset (Name)
  dataToPlot <- reactive({
    if (input$collapseLines == "yes") {
      collapseFlag <- 0
    } else {
      collapseFlag <- 1
    }
    return(lapply(input$selDatasets, function(y) {
      ds <- datasets[[y]]
      genesOfInterest <- strsplit(input$selGenes, split = '[\r\n]')[[1]] 
      lst <- lapply(genesOfInterest, function(x) {
        ret <- ds[grep(x, ds[,1]),]
        if (nrow(ret) == 0) {
          return(NA)
        } else {
          return(ret)
        }
      })
      genesNotFound <- genesOfInterest[which(is.na(lst))]
      lst <- lst[which(!is.na(lst))]
      lns <- lapply(lst, function(x) {
        if (input$collapseLines == "yes") {
          return(makeLine(x, T))
        } else {
          return(makeLine(x, F))
        }
      })
      xMax <- max(unlist(lapply(lns, function(x) return(x[,1])))) + 1
      yMin <- min(unlist(lapply(lns, function(x) return(x[,2])))) - 1
      yMax <- max(unlist(lapply(lns, function(x) return(x[,2])))) + length(lns)*collapseFlag
      return(list(Plot = lns, xMax = xMax, yMin = yMin, yMax = yMax, Name = y, notFound = genesNotFound, DS = y))
    }))
  })
  
  # Defines the plotting windows based on the max and min x and y values for all plots
  # This is so the plot scales are consistent.
  plotWindow <- reactive({
    maxX <- max(unlist(lapply(dataToPlot(), function(x) return(x$xMax))))
    minX <- -9
    minY <- min(unlist(lapply(dataToPlot(), function(x) return(x$yMin))))
    maxY <- max(unlist(lapply(dataToPlot(), function(x) return(x$yMax))))
    if (input$collapseLines == "yes") {
      maxX <- maxX + 6
      minX <- -0.5
    } 
    
    return(list(right = maxX, left = minX, top = maxY, bottom = minY))
  })
  
  output$GNF <- renderPrint({
    lapply(dataToPlot(), function(d) {
      return(paste("In", d$DS, "we didn't find", d$notFound))
    })
  })
  
  # Renders the plots. One plot for each selected dataset. The plot scales based on the max and min y-values
  output$Plots <- renderUI({
      lapply(dataToPlot(), function(d) {
        if (input$collapseLines == "yes") {
          collapseFlag <- 0
        } else {
          collapseFlag <- 1
        }
        
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
            text(-5*collapseFlag + (1 - collapseFlag)*((i$x[length(i$x)]) + 3), 
                 vShift*collapseFlag + (1 - collapseFlag)*(i$y[length(i$y)]), 
                 labels = i$gene)
            vShift <- vShift + collapseFlag
          }
        }, height = max(20, (plotWindow()$top - plotWindow()$bottom) * (3100/(plotWindow()$top - plotWindow()$bottom) + 800) / 35))
      })
  })
}

shinyApp(ui, server)