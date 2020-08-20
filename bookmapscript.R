library(leaflet)
library(dplyr)

bookdata <- read.csv("./bookmap.csv")
bookdata <- as.data.frame(bookdata)

popup <- paste('<b>',bookdata$title, "</b> <br> <em>",bookdata$author,  "</em> <br> ",bookdata$review, " <br> <b>",bookdata$by," <b>")
my_map <- data.frame(lng = bookdata$lng,lat = bookdata$lat)

print("20th August 2020")
my_map %>%
  leaflet() %>%
  addTiles()  %>%
  addMarkers(clusterOptions = markerClusterOptions(), popup = popup) %>%


  

