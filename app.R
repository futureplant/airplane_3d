library(tidyverse)
library(mapdeck)
source('scripts/API_calls.R')
source('scripts/polygon_operations.R')


planes <- getPlaneData("lamin=51.000&lomin=3.000&lamax=53.000&lomax=7.000")
isoLinesDBvalues <- c(45,50,55,60,65,70,75)
polygons <- create_polygons(planes, isoLinesDBvalues) #  polygons are constructed on the bases of plane data and noise levels


planes$lon = unlist(map(planes$geometry,1))
planes$lat = unlist(map(planes$geometry,2))
planes$Z = planes$geo_altitude

planes <- as.data.frame(planes)
planes$geometry<-NULL





key <- 'pk.eyJ1Ijoiam9leWhvZGRlIiwiYSI6ImNrMDNqYXE4aTJmamgzbnE5eDJ5cHExZHAifQ.k4AdDHOgCofSV9aErOhdYg'

mapdeck(token = key, style = mapdeck_style("dark")) %>%
  add_pointcloud(
    data = planes
    , lon = "lon"
    , lat = "lat"
    , elevation = 'Z'
    , layer_id = 'point'
    , fill_colour = "Z"
  ) %>%
  add_polygon(
    data = polygons
    , fill_colour = "Noise"
    , palette = "reds" #ylorrd
    , tooltip = "Noise"
    , fill_opacity = 124)
