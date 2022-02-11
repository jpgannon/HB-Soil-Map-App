#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(terra)
library(leaflet)
library(raster)
library(tmap)

path <- "ProbGrids/"
#path <- "~/My Drive (jpgannon@vt.edu)/HB-Soil-Map-App/HB-Soil-Predictions/ProbGrids/"

modelname <- "hbd9310h5mtwimrvt100t2000re"

#Read probability Rasters
Bh  <- rast(paste0(path, modelname, "Bh.tif"))
Bhs <- rast(paste0(path, modelname, "Bhs.tif"))
Bi  <- rast(paste0(path, modelname, "Bi.tif"))
E   <- rast(paste0(path, modelname, "E.tif"))
H   <- rast(paste0(path, modelname, "H.tif"))
I   <- rast(paste0(path, modelname, "I.tif"))
O   <- rast(paste0(path, modelname, "O.tif"))
Typ <- rast(paste0(path, modelname, "T.tif"))


#read hillshade
hillshade <- rast("dem5m_hillshade.tif")

#function to classify grids
#based on threshold
classifyHPU <- function(probgrid, threshold, value){
  ## from-to-becomes
  # classify the values into 2 groups 
  # all values from >= 0 to <= 0.2 and become 1, etc
  classMat <- c(0, threshold, NA,
                threshold, 1, value) %>%
    matrix(ncol = 3, byrow = TRUE)
  
  output <- classify(probgrid, classMat)
}
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    
    
    output$hpumap <- renderTmap({
      #classify
      BhClassified  <- classifyHPU(Bh, input$BhProb, 1)
      BhsClassified <- classifyHPU(Bhs, input$BhsProb, 2)
      BiClassified  <- classifyHPU(Bi, input$BiProb, 3)
      EClassified   <- classifyHPU(E, input$EProb, 4)
      HClassified   <- classifyHPU(H, input$HProb, 5)
      IClassified   <- classifyHPU(I, input$IProb, 6)
      OClassified   <- classifyHPU(O, input$OProb, 7)
      TypClassified <- classifyHPU(Typ, input$TypProb, 8)
      
        HPUcolors <- c("green", "brown", "darkgreen", "grey",
                       "black", "orange", "blue", "yellow")
        
        trans <- 0.5
        
        tmap_mode("view")
        tm_shape(hillshade, raster.downsample = FALSE) + 
            tm_raster(style = "cont", palette = "-Greys", legend.show = FALSE)+
              tm_shape(BhClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[1], NA), alpha = trans)+
              tm_shape(BhsClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[2], NA), alpha = trans)+
              tm_shape(BiClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[3], NA), alpha = trans)+
              tm_shape(EClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[4], NA), alpha = trans)+
              tm_shape(HClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[5], NA), alpha = trans)+
              tm_shape(IClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[6], NA), alpha = trans)+
              tm_shape(OClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[7], NA), alpha = trans)+
              tm_shape(TypClassified, raster.downsample = FALSE) + 
            tm_raster(palette = c(HPUcolors[8], NA), alpha = trans) +
            tm_scale_bar()

    })

})
