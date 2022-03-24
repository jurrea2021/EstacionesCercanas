install.packages(setdiff('terra', rownames(installed.packages())), repos='https://rspatial.r-universe.dev')
install.packages(setdiff('raster', rownames(installed.packages())), repos='https://rspatial.r-universe.dev')

packs = c("mapview","leaflet","sf","dplyr","plotly","rgdal","leafem","readxl","shinydashboard","stringr","tidyr","dygraphs","xts","DT","leaflet.extras","bslib","shinythemes","shinyalert","RSQLite")
install.packages(setdiff(packs, rownames(installed.packages()))) 

library(leaflet)
library(raster)
library(sf)
library(dplyr)
try(library(raster),silent = T)
library(plotly)
library(rgdal)
library(readxl)
library(stringr)
library(tidyr);
try(library(mapview),silent = T);
try(library(leafem),silent = T)
library(dygraphs);library(shinydashboard)
library(xts);library(DT);library(shinyalert);library(RSQLite)
library(leaflet.extras);library(bslib);library(shinythemes)
library(DT)

RUTA = "data/"

SZH = sf::st_read(paste0(RUTA,"SZH_QGIS_V2.json"))
print(1)
ARCHIVO = as.data.frame(read_excel(paste0(RUTA,"EstacionesCercanasClimatologicas_V5_V2.xlsx"),range = "A2:Z590"))
print(2)
CNE_IDEAM = as.data.frame(read_excel(paste0(RUTA,"CNE_IDEAM.xls")))
CNE_IDEAM$CODIGO = as.numeric(CNE_IDEAM$CODIGO)
print(3)