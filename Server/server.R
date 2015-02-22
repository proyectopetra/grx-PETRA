
library(shiny)

shinyServer(function(input, output) {
  source("incidents.R")
  source("stations.R")
  
  incidents <- tryCatch(get_dgt_traffic(), error = function(e) data.frame())
  
  output$incidents <- renderDataTable(
    incidents
  )
  
  output$cities <- renderUI({
    selectInput("city", "City", as.character(unique(incidents$Provincia)))
  })
  
  output$stations_sum <- renderTable(t(summary(stations)))
  
  output$stations_hist <- renderPlot(stations_by_road())
  
  output$stations_prov <- renderPlot(stations_by_province())
})
