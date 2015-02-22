
library(shiny)

shinyServer(function(input, output) {
  source("incidents.R")
  
  incidents <- get_dgt_traffic()
  
  output$incidents <- renderDataTable(
    incidents
  )
  
  output$cities <- renderUI({
    selectInput("city", "City", as.character(unique(incidents$Provincia)))
  })
})
