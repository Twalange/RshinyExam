library(shiny)
library(tidyverse)
library(DT)
library(bslib)
library(thematic)
library(systemfonts)

thematic::thematic_shiny(font = "Noto Sans Mono")

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty",
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

server <- function(input, output) {
  rvDiamonds <- reactiveValues(df = NULL, dotcolor = "#AA0000", textFilters = "Lorem ipsum")
  listenPriceAndColor <- reactive({
    list(input$priceFilter, input$colorFilter)
  })

  observeEvent(listenPriceAndColor(), {
    rvDiamonds$df <- diamonds %>%
      select(!c(x, y, z)) %>%
      filter(price < input$priceFilter & color == input$colorFilter)
    rvDiamonds$textFilters <- paste0("prix: ", input$priceFilter, " & color: ", input$colorFilter)
  })

  observeEvent(input$shouldScatterPlotBePink, {
    rvDiamonds$dotcolor <- if_else(input$shouldScatterPlotBePink == "Oui", "#ffC0cb", "#5a5a5a")
  })

  observeEvent(input$showNotification, {
    showNotification(
      rvDiamonds$textFilters,
      type = "message",
    )
  })

  output$diamondPlot <- renderPlot({
    req(rvDiamonds$df, rvDiamonds$dotcolor)
    rvDiamonds$df %>%
      ggplot(aes(x = carat, y = price)) +
      geom_point(colour = rvDiamonds$dotcolor) +
      ggtitle(rvDiamonds$textFilters)
  })

  output$DTOutput <- renderDT({
    req(rvDiamonds$df)
    rvDiamonds$df
  })
}

shinyApp(ui = ui, server = server)