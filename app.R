library(shiny)
library(tidyverse)
library(DT)
library(bslib)
library(thematic)

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
  h2("Exploration des Diamants"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "shouldScatterPlotBePink",
        label = "Colorier les points en rose ?",
        choices = c("Oui", "Non")
      ),
      selectInput(
        inputId = "colorFilter",
        label = "Choisir une couleur à filtrer :",
        choices = levels(diamonds$color)
      ),
      sliderInput(
        inputId = "priceFilter",
        label = "Prix maximum :",
        min = 300,
        max = 20000,
        value = 5000
      ),
      actionButton(
        inputId = "showNotification",
        label = "Afficher une notification",
      )
    ),
    mainPanel(
      textOutput("textFilters"),
      plotOutput("diamondPlot"),
      DT::DTOutput("DTOutput")
    )
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)