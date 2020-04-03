#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(tidyverse)
library(viridis)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(spdep)



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  # Application title
  titlePanel("Visualizing Spatial Autocorrelation"),
  sidebarLayout(
  # Sidebar with a slider input for number of bins 
    sidebarPanel(
       sliderInput("sa",
                   "Spatial Autocorrelation Coefficient:",
                   min = -.9,
                   max = .9,
                   value = 0),

      p("   
        Use the slider to adjust the spatial autocorrelation coefficient and observe how the data changes in the
        figures to the right."),
      p("
        Spatial autocorrelation (SA) is the correlation of values in a single variable as a result of
        geographic proximity. The result is neighbors sharing similar values. SA is often measured
        as a correlation coefficient that ranges from -1 to +1. Negative SA is the non-random
        separation of similar values (e.g. a checkerboard pattern). Positive SA results in the spatial clustering
        of similar values."),

       br(),
       
    selectInput("lag",
                "Order of Contiguity:",
                c(1,2, 3, 4)
                ),
    p("
        Change the order of contiguity and observe how the pattern of SA changes.
      The ''order'' defines how many sets of neighbors are impacted by SA. 
      First order includes only the immediate neighbors. Second order includes
      your neighbors and your neighbors neighbors. And so on."),
    
      p("
        Spatial autocorrelation also has a distance across works.
      This distance is highly context specific (social distance ≠ physical distance) and we must take care to think
      hard about which types of distance matter and explore how our decisions impact the results. 
      In many situations, contiguity of areal units is a reasonable approximation of the spatial structure of the data. 
      "),
      

      
    br(), 
    
    actionButton("goButton", "Re-Simulate Data"),
    p("Data is drawn from a normal distribution with a mean
      of 0 and standard deviation of 2. As the autocorrelation increases
      the raw data is rescaled to fit between -5, and 5.")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("caption")),
      plotlyOutput("plot"),
      br(),
      plotlyOutput("scatter")
    )
  )
))

