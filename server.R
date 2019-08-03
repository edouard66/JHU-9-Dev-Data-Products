library(UsingR)
library(geosphere)
library(leaflet)
hospitals <- data.frame(name = c("Salpetriere", "Bichat", "Robert-Debre", "Lariboisiere","Georges-Pompidou","Necker","Cochin","Armand-Trousseau","Saint-Antoine","Tenon","Saint-Louis","Hotel Dieu" ), 
                        lat = c(48.8378796,48.8989884,48.8799187,48.8829237,48.8393,48.8460247,48.8369622,48.841958,48.8485624,48.8663567,48.8749,48.8539489),
                        lng = c(2.3652543,2.3301387,2.4028936,2.3530628,2.2706000000000586,2.3132671,2.3401797,2.4066039,2.3824305,2.4015104,2.3654000000000224,2.3477596))
hospitals$name <- as.character(hospitals$name)

shinyServer(  
  function(input, output) { 
    
    calc_dist <- reactive({
    for (i in 1:dim(hospitals)[1]) {
      hospitals$dist[i] <- distm(c(input$lng, input$lat), c(hospitals$lng[i], hospitals$lat[i]), fun = distHaversine)
    }
      hospitals[order(hospitals$dist)[1],]
    })
    
    df <- reactive ({
      data.frame(lat = c(input$lat,calc_dist()[1,2]),
                 lng = c(input$lng,calc_dist()[1,3]),
                 type = c("departure","hospital"),
                 content = c("Your position",paste("Hopital",calc_dist()[1,1])))
    })
    
    hospitalIcon <- reactive ({
      makeIcon(
      iconUrl = ifelse(df()$type == "hospital",
                       "https://image.flaticon.com/icons/svg/504/504276.svg", 
                       "https://png.pngtree.com/svg/20170505/7b67d2699c.svg"),
      iconWidth = 31*215/230, iconHeight = 31, 
      iconAnchorX = 31*215/230/2, iconAnchorY = 16
      )
      })
    
    timeToHospital <- reactive ({
      60*(calc_dist()[1,4]/1000)/as.numeric(input$speed)
    })
    
    output$name <- renderText({      
      paste("Hopital ", calc_dist()[1,1])
    }) 
    output$distance <- renderText({      
      paste("Distance from your position = ", round(calc_dist()[1,4]/1000,3),"km")
    })      
    output$time <- renderText({      
      paste("Estimated time to destination = ", round(timeToHospital(),0),"minutes")
    }) 

    output$hospitalsmap <- renderLeaflet({
      leaflet(data = df()) %>%
        addTiles() %>%
        setView(2.34,48.86, zoom = 12) %>%
        addMarkers(lat = ~lat, lng = ~lng, icon = hospitalIcon(), popup = ~content)
    })
    }
)