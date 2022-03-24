#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  fluidRow(
    column(4,
           leafletOutput("mapClimat"),
           leafletOutput("mapPluv")
           ),
    column(8,
           fluidRow(
             tabsetPanel(
               tabPanel(strong("tabla"),
                        div(dataTableOutput("tabla"),style = "font-size:70%")
               ),
               tabPanel(strong("Arbol"),
                        imageOutput("myImage",height = 800)
               )
             )
           ),
           fluidRow(
             column(6,
                    imageOutput("myImage2",height = 800)),
             column(6,
                    imageOutput("myImage3",height = 800)
                    )
             
           )
           )
    
  )
))