library(shiny)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(spdep)

n  <- 100 # number of obs to simulate

# Set up a square lattice region
simgrid <- expand.grid(x = 1:10, y = 1:10)
X  <- rnorm(n, 0 , 2)

## This function simulates the data given a value of 
## spatial autocorrelation
sa_var  <- function(rho_value, dat, lag){
  ##inverse weight matrix
  if(lag > 1){
      w  <- nblag_cumul(nblag(cell2nb(10,10, type = "queen"), lag))
  } else {
    w <- cell2nb(10, 10, type = "queen")
  }
  iw  <- invIrM(w, rho_value)
  result  <- iw %*% dat
  tibble(z = result)
}

# Actual Server Information
shinyServer(function(input, output) {
  rv <- reactiveValues(data=X)

  observeEvent(input$goButton,{
    rv$data <- rnorm(100, 0, 2)
  })

  formulaText <- reactive({
    paste("Spatial Autocorrelation = ", input$sa)
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
      #scale_fill_gradientn(colors = viridis_pal()(9), limits=c(-12, 12))
      scale_fill_viridis_c(limits = c(-5, 5), oob = scales::squish) +
      theme_void() + 
      labs(fill = "Value")
    ggplotly(p)
  })
  
  output$scatter <- renderPlotly({
      X <- rv$data
      z <- sa_var(input$sa, X, input$lag)
      ## Create the spatial weights list from nb list
      w <- cell2nb(10, 10, type = "queen")
      listw <- nb2listw(w) 
      sim_data <- bind_cols(simgrid, z)
      sim_data$l <- lag.listw(x = listw, sim_data$z)
      p2 <- ggplot(sim_data, aes(x = z, y = l, color = z)) +
        geom_hline(yintercept = 0) + 
        geom_vline(xintercept = 0) +
        geom_point() +
        scale_color_viridis_c(limits = c(-5, 5), 
                              oob = scales::squish, guide = FALSE) + 
        geom_smooth(method = 'lm', se = FALSE, color = "red") +
        coord_equal() + 
        theme_minimal() + 
        labs(x = "Values", y = "Average Values of Neighboring Cells")
      ggplotly(p2)
  })
  
}
)