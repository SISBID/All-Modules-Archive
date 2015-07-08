library(shiny)
library(ggvis)
data("mpg", package = "ggplot2")

ui <- fluidPage(
  selectInput("x", "x", names(mpg)),
  selectInput("y", "y", names(mpg), selected = names(mpg)[2]),
  ggvisOutput("p")
)

draw_plot <- function(xvar, yvar) {
  mpg %>%
    ggvis(xvar, yvar) %>%
    layer_points()
}
# draw_plot(0.2)

server1 <- function(input, output) {
  draw_plot(reactive(as.name(input$x)), reactive(as.name(input$y))) %>%
    bind_shiny("p")
}

server2 <- function(input, output) {
  reactive(draw_plot(as.name(input$x), as.name(input$y))) %>%
    bind_shiny("p")
}

# runApp(shinyApp(ui, server1))
# runApp(shinyApp(ui, server2))
