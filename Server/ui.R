
library(shiny)

shinyUI(navbarPage(
  "PETRA", 
  id = "nav",

  tabPanel("Map",
    div(class = "outer",
      tags$head(
        includeCSS("css/main.css"),
        tags$link(
          href = "http://libs.cartocdn.com/cartodb.js/v3/3.11/themes/css/cartodb.css",
          rel = "stylesheet"
        ),
        tags$script(
          src = "http://libs.cartocdn.com/cartodb.js/v3/3.11/cartodb.js",
          type = "text/javascript"
        )
      ),
      
      sidebarPanel(id = "controls", width = 3,
        h4("Parameters"),
        uiOutput("cities"),
        sliderInput("zoom", "Zoom", 1, 10, 1)
        
      ),
      
      div(id = "map"),

      includeScript("js/maps.js")
    )
  ),
  tabPanel("Traffic stations",
    tabsetPanel(id = "pages", type = "pills", selected = "Exploration",
      tabPanel("Exploration",
        wellPanel(
         h3("Summary of stations"),
         tableOutput("stations_sum"),
         h3("Number of stations by province"),
         plotOutput("stations_prov"),
         h3("Number of roads by number of stations"),
         plotOutput("stations_hist")
        )
      ),
      tabPanel("Data",
        wellPanel(
          dataTableOutput("stations")
        )       
      )
    )
  ),
  tabPanel("Traffic incidents", 
    div(
      wellPanel(
        dataTableOutput("incidents")
      )  
    )
  ),
  tabPanel("About",
    div(
      h2("About PETRA"),
      tags$p("PETRA (Predicción del Estado de Tráfico)")
    ))
))
