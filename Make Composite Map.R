library(tidyverse)
library(terra)
library(leaflet)
library(raster)

path <- "~/My Drive (jpgannon@vt.edu)/HB-Soil-Map-App/HB-Soil-Predictions/ProbGrids/"

modelname <- "hbd9310h5mtwimrvt100t2000re"

#Read probability Rasters
Bh  <- rast(paste0(path, modelname, "Bh.tif"), names = "Bh")
Bhs <- rast(paste0(path, modelname, "Bhs.tif"))
Bi  <- rast(paste0(path, modelname, "Bi.tif"))
E   <- rast(paste0(path, modelname, "E.tif"))
H   <- rast(paste0(path, modelname, "H.tif"))
I   <- rast(paste0(path, modelname, "I.tif"))
O   <- rast(paste0(path, modelname, "O.tif"))
Typ <- rast(paste0(path, modelname, "Typ.tif"))

#change names (how to do this in rast() function?)
names(Bh) <- "Bh"
names(Bhs) <- "Bhs"
names(Bi) <- "Bi"
names(E) <- "E"
names(H) <- "H"
names(I) <- "I"
names(O) <- "O"
names(Typ) <- "Typ"


#read hillshade
hillshade <- rast(
  "~/My Drive (jpgannon@vt.edu)/HB-Soil-Map-App/HB-Soil-Predictions/dem5m_hillshade.tif")



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

#Set threhold probabilities
BhThreshold  <- 0.5
BhsThreshold <- 0.5
BiThreshold  <- 0.5
EThreshold   <- 0.5
HThreshold   <- 0.5
IThreshold   <- 0.5
OThreshold   <- 0.5
TypThreshold <- 0.5

#classify
BhClassified  <- classifyHPU(Bh, BhThreshold, 1)
BhsClassified <- classifyHPU(Bhs, BhsThreshold, 2)
BiClassified  <- classifyHPU(Bi, BiThreshold, 3)
EClassified   <- classifyHPU(E, EThreshold, 4)
HClassified   <- classifyHPU(H, HThreshold, 5)
IClassified   <- classifyHPU(I, IThreshold, 6)
OClassified   <- classifyHPU(O, OThreshold, 7)
TypClassified <- classifyHPU(Typ, TypThreshold, 8)

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

#leaflet() %>%
#  addRasterImage(raster(hillshade)) %>%
#  addRasterImage(raster(BhClassified), colors = HPUcolors[1]) %>%
#  addRasterImage(raster(BhsClassified), colors = HPUcolors[2]) %>%
#  addRasterImage(raster(BiClassified), colors = HPUcolors[3]) %>% 
#  addRasterImage(raster(EClassified), colors = HPUcolors[4]) %>%
#  addRasterImage(raster(HClassified), colors = HPUcolors[5]) %>%
#  addRasterImage(raster(IClassified), colors = HPUcolors[6]) %>%
#  addRasterImage(raster(OClassified), colors = HPUcolors[7]) %>%
#  addRasterImage(raster(TypClassified), colors = HPUcolors[8])
