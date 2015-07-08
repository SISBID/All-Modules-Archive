library(shiny)

ui <- fluidPage(
  titlePanel("This is a title"),
  sidebarLayout(
    sidebarPanel("This is a sidebar"),
    mainPanel("This is the main panel")
  )
)

ui
attributes(ui)
runApp(shinyApp(ui, function(input, output) {}))

