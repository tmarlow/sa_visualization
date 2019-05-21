library(shiny)
library(ggplot2)
library(RColorBrewer)
library(plotly)


n  <- 100 # number of obs to simulate

# Set up a square lattice region
simgrid <- expand.grid(x = 1:10, y = 1:10)
X  <- rnorm(n, 0 , 10)

## This function simulates the data given a value of 
## spatial autocorrelation
sa_var  <- function(rho_value, dat, lag){
  ##inverse weight matrix
  w  <- nblag_cumul(nblag(cell2nb(10,10, type = "queen"), lag))
  iw  <- invIrM(w, rho_value)
  result  <- iw %*% dat
  tibble(z = result)
}

# Actual Server Information
shinyServer(function(input, output) {
  rv <- reactiveValues(data=X)

  observeEvent(input$goButton,{
    rv$data <- rnorm(100, 0, 10)
  })

  formulaText <- reactive({
    paste("SA = ", input$sa)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  output$plot <- renderPlotly({
    X <- rv$data
    z <- sa_var(input$sa, X, input$lag) 
    sim_data <- bind_cols(simgrid, z)
    p <- ggplot(sim_data, aes(x = x, y = y, fill = z)) +
      geom_raster() +
      scale_fill_viridis_c() +
      theme_void() + 
      theme(legend.position = "bottom")
    ggplotly(p)
  })
}
)