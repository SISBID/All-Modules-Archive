library(shiny)
library(ggvis)
data("mpg", package = "ggplot2")

ui <- fluidPage(
  titlePanel("Smoothing"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("span", "", 0.25, 1, 1, step = 0.01)
    ),
    mainPanel(
      ggvisOutput("p")
    )
  )
)

draw_plot <- function(span) {
  mpg %>%
    ggvis(~displ, ~hwy) %>%
    layer_points() %>%
    layer_smooths(span = span)
}
# draw_plot(0.2)

server <- function(input, output) {
  draw_plot(reactive(input$span)) %>%
    bind_shiny("p")
}
runApp(shinyApp(ui, server))

