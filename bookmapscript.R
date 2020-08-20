library(leaflet)
library(dplyr)

bookdata <- read.csv("./bookmap.csv")
bookdata <- as.data.frame(bookdata)
bookicon <- makeIcon(iconUrl = "./book.png",iconWidth = 31*215/230, iconHeight = 31,iconAnchorY = 31*215/230/2, iconAnchorX = 16 )

popup <- paste('<b>',bookdata$title, "</b> <br> <em>",bookdata$author,  "</em> <br> ",bookdata$review, " <br> <b>",bookdata$by," <b>")
my_map <- data.frame(lng = bookdata$lng,lat = bookdata$lat)

my_map %>%
  leaflet() %>%
  addTiles()  %>%
  addMarkers(clusterOptions = markerClusterOptions(), popup = popup, icon = bookicon)

