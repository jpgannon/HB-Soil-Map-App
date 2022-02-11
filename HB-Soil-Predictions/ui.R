#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(rgdal)
library(terra)
library(leaflet)
library(raster)
library(tmap)




# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("HPU Characterization"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("BhProb",
                        "Bh Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("BhsProb",
                        "Bhs  Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("BiProb",
                        "Bimodal Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("EProb",
                        "E Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("HProb",
                        "Histosol Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("IProb",
                        "Inceptisol Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("OProb",
                        "O Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("TypProb",
                        "Typical Treshold Probability:",
                        min = 0,
                        max = 1,
                        value = 0.5),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tmapOutput("hpumap", height = 800)
        )
    )
))
