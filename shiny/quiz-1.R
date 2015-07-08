# DON'T LOOK AT ME!

library(shiny)

ui <- fluidPage(
  titlePanel(
    "My App"
  ),
  sidebarLayout(
    sidebarPanel(
      "Often ", strong("controls"), " are placed in sidebar"
    ),
    mainPanel(
      "Often ", strong("output"), "is placed in the main painel"
    )
  )
)

runApp(shinyApp(ui, function(input, output) {}))
