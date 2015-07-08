library(shiny)
library(ggvis)
library(MASS)
data("mpg", package = "ggplot2")

ui <- fluidPage(
  titlePanel("Smoothing"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("span", "Smooth span", 0.25, 1, 1, step = 0.01),
      selectInput("model", "Which model?", c("lm", "rlm", "loess"))
    ),
    mainPanel(
      ggvisOutput("p")
    )
  )
)

server <- function(input, output) {
  mpg %>%
    ggvis(~displ, ~hwy) %>%
    layer_points() %>%
    layer_smooths(span = reactive(input$span),
      stroke = "smooth"
    ) %>%
    layer_model_predictions(
      model = reactive(input$model),
      stroke = "model"
    ) %>%
    bind_shiny("p")
}
runApp(shinyApp(ui, server))

