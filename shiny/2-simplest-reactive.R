library(shiny)

ui <- fluidPage(
  sliderInput("number", "Pick a number", 1, 10, value = 5),
  p("You picked: ", textOutput("result", inline = TRUE))
)

server <- function(input, output, session) {
  message("Initialising")
  output$result <- renderText({
    message("Updating")
    input$number
  })
}

runApp(shinyApp(ui, server))
