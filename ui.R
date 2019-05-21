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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  # Application title
  titlePanel("Visualizing Spatial Autocorrelation"),
  sidebarLayout(
  # Sidebar with a slider input for number of bins 
    sidebarPanel(
       sliderInput("sa",
                   "Autocorrelation Coefficient:",
                   min = -.9,
                   max = .9,
                   value = 0),
       
       br(),
       
    selectInput("lag",
                "Order of Adjacency:",
                c(1,2, 3, 4, 5)
                ),
    
    br(), 
    
    actionButton("goButton", "Re-Run the Model")),
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("caption")),
      plotlyOutput("plot")
    )
  )
))

