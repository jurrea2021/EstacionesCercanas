library(shiny)
source("./global.R")


shinyServer(function(input, output) {
  
  estClimat = reactive({
    estA = unique(ARCHIVO$codigoClim)
    estClim = CNE_IDEAM[CNE_IDEAM$CODIGO %in% estA,]
    # estClim$id = length(1:dim(estClim)[1])
    return(estClim)
  })
  
  output$mapClimat = renderLeaflet({
    estClimat2 = estClimat()
    leaflet() %>% 
      addTiles(group = "Google Maps") %>%
      addProviderTiles("Esri.WorldImagery",group = "WorldImagery") %>%
      addProviderTiles(providers$Stamen.TonerLines,group = "WorldImagery") %>%
      addProviderTiles(providers$Stamen.TonerLabels,group = "WorldImagery") %>%
      addCircleMarkers(data = estClimat2,group = "climaticos",lng = estClimat2$longitud,lat = estClimat2$latitud,color = "#0917F1",layerId = estClimat2$CODIGO, label = ~ CODIGO) %>% 
      addLayersControl(
        baseGroups = c("Google Maps","WorldImagery"),
        overlayGroups = c("Climaticos"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      leaflet::addLegend("topright", 
                         colors =c("#0917F1"),
                         labels= c("Estacion Climatologica"),
                         opacity = 1)
  })
  
  # output$tabla = renderDataTable(iris)
  
  
  observeEvent(input$mapClimat_marker_click,{

    codigoZ = input$mapClimat_marker_click$id
    
    output$myImage = renderImage({
      filename <- normalizePath(file.path('www/ArbolDecision/',paste0(codigoZ,".png")))
      list(src = filename,
           contentType = "www/ArbolDecision/png",
           width = 500,
           height = 500,
           alt = paste0(codigoZ,'.png'))
    }, deleteFile = FALSE)
    
    output$myImage11 = renderImage({
      filename <- normalizePath(file.path('www/ArbolDecisionDHIME/',paste0(codigoZ,".png")))
      list(src = filename,
           contentType = "www/ArbolDecisionDHIME/png",
           width = 500,
           height = 500,
           alt = paste0(codigoZ,'.png'))
    }, deleteFile = FALSE)
    
    estPluv = reactive({
      estB = ARCHIVO %>% filter(codigoClim == codigoZ)
      estClim = CNE_IDEAM[CNE_IDEAM$CODIGO %in% estB$codigo10km,]
      return(estClim)
    })
    
    estPluv2 = reactive({
      estC = ARCHIVO %>% filter(codigoClim == codigoZ)
      estC = estC[,c("codigo10km","estacion...10","categoria...13","correlacion_aseguradas")]
      estC
    })
    
    estPluv3 = reactive({
      estC = ARCHIVO %>% filter(codigoClim == codigoZ)
      estC = estC[,c("codigo10km","estacion...10","categoria...13","correlacion_DHIME")]
      estC
    })
    
    estClim = reactive({
      estClimA = CNE_IDEAM[CNE_IDEAM$CODIGO %in% codigoZ,]
      return(estClimA)
    })
    
    # output$tabla = renderDataTable({DT::datatable(estPluv(),options = list(scrollX = T,pageLength = 5),rownames = F)})
    output$tabla = renderDataTable(estPluv2())
    output$tabla2 = renderDataTable(estPluv3())
    
    output$mapPluv = renderLeaflet({
      estClimat3 = estPluv()
      estClimat4 = estClim()
      SubRegs1 = SZH[SZH$NOMSZH == CNE_IDEAM$SUBZONA_HIDROGRAFICA[CNE_IDEAM$CODIGO == estClimat4$CODIGO],]

      leaflet() %>% 
      addTiles(group = "Google Maps") %>% setView(estClimat4$longitud,estClimat4$latitud,zoom = 11) %>% 
        addProviderTiles("Esri.WorldImagery",group = "WorldImagery") %>%
        addProviderTiles(providers$Stamen.TonerLines,group = "WorldImagery") %>%
        addProviderTiles(providers$Stamen.TonerLabels,group = "WorldImagery") %>%
      addPolygons(data = SubRegs1,group = "SZH", weight = 1, smoothFactor = 1,opacity = 1,color = "#6CAB96", fillOpacity = 0.8,label = ~ NOMSZH) %>% 
      addCircleMarkers(data = estClimat3,group = "climaticos",lng = estClimat3$longitud,lat = estClimat3$latitud,color = "red",layerId = estClimat3$CODIGO, label = ~ CODIGO) %>% 
      addCircleMarkers(data = estClimat4,group = "climaticos",lng = estClimat4$longitud,lat = estClimat4$latitud,color = "#0917F1", label = ~ CODIGO) %>% 
        addLayersControl(
          baseGroups = c("Google Maps","WorldImagery"),
          overlayGroups = c("Climaticos","SZH"),
          options = layersControlOptions(collapsed = FALSE)
        ) %>% 
        addMeasure(primaryLengthUnit="kilometers",activeColor = "#F41A0C",completedColor = "#F1A709",primaryAreaUnit = "sqmeters",
                 secondaryAreaUnit = "hectares")
        
   })
    
    observeEvent(input$mapPluv_marker_click,{
      codigoW = input$mapPluv_marker_click$id
      
      output$myImage2 = renderImage({
        filename <- normalizePath(file.path('www/seriesTiempo/',paste0(codigoZ,"_",codigoW,".png")))
        list(src = filename,
             contentType = "www/seriesTiempo/png",
             width = 500,
             height = 500,
             alt = paste0(codigoZ,"_",codigoW,".png"))
      }, deleteFile = FALSE)
      
      output$myImage21 = renderImage({
        filename <- normalizePath(file.path('www/seriesTiempoDHIME/',paste0(codigoZ,"_",codigoW,".png")))
        list(src = filename,
             contentType = "www/seriesTiempoDHIME/png",
             width = 500,
             height = 500,
             alt = paste0(codigoZ,"_",codigoW,".png"))
      }, deleteFile = FALSE)
      
      
      output$myImage3 = renderImage({
        filename <- normalizePath(file.path('www/Correlacion/',paste0(codigoZ,"_",codigoW,".png")))
        list(src = filename,
             contentType = "www/Correlacion/png",
             width = 500,
             height = 500,
             alt = paste0(codigoZ,"_",codigoW,".png"))
      }, deleteFile = FALSE)
      
      output$myImage31 = renderImage({
        filename <- normalizePath(file.path('www/CorrelacionDHIME/',paste0(codigoZ,"_",codigoW,".png")))
        list(src = filename,
             contentType = "www/CorrelacionDHIME/png",
             width = 500,
             height = 500,
             alt = paste0(codigoZ,"_",codigoW,".png"))
      }, deleteFile = FALSE)
      
    })
    
  }
  )
}
)
