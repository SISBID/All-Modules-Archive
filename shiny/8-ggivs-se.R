library(shiny)
library(ggvis)
data("mpg", package = "ggplot2")

ui <- fluidPage(
  titlePanel("Smoothing"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("span", "", 0.25, 1, 1, step = 0.01),
      checkboxInput("se", "Show standard error?")
    ),
    mainPanel(
      ggvisOutput("p")
    )
  )
)

server1 <- function(input, output) {
  mpg %>%
    ggvis(~displ, ~hwy) %>%
    layer_points() %>%
    layer_smooths(
      span = reactive(input$span),
      se = reactive(input$se)
    ) %>%
    bind_shiny("p")
}

server2 <- function(input, output) {
  reactive(
    mpg %>%
      ggvis(~displ, ~hwy) %>%
      layer_points() %>%
      layer_smooths(span = input$span, se = input$se)
  ) %>% bind_shiny("p")
}

# runApp(shinyApp(ui, server1))
# runApp(shinyApp(ui, server2))
