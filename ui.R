library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(  
  headerPanel("Find the closest hospital"), 
  sidebarPanel(    
    sliderInput('lat', 'Indicate your latitude',value = 48.86, min = 48.83, max = 48.90, step = 0.005),
    sliderInput('lng', 'Indicate your longitude',value = 2.34, min = 2.27, max = 2.41, step = 0.005),
    sliderInput('speed', 'Choose a speed',value = 30, min = 10, max = 60, step = 1,)  ),
  mainPanel(    
    h3("The closest hospital to your position is : "),
    textOutput('name'),  
    textOutput('distance'),
    textOutput('time'),
    leafletOutput("hospitalsmap"),
    h6("How it works : input the coordinates of your current position on the sidebar sliders to see the nearest hospital. The speed feature helps estimating the time to the hospital." ),
    tags$head(tags$style("#name{color: green;
                                 font-size: 20px;
                                 font-style: bold;
                                 text-align : center;
                                 }",
                         "#distance{font-size: 12px;
                                 text-align : center;
                                 }",
                         "#time{font-size: 12px;
                                 text-align : center;
                                 }"
    )
    )
  )
))