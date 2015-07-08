library(shiny)

ui <- fluidPage(
  titlePanel("Dice roller"),
  sidebarPanel(
    numericInput("n", "How many dice would you like to roll?", 1, min = 1),
    selectInput("sides", "How many sides?", c(6, 12, 20))
  ),
  mainPanel(
    textOutput("rolls")
  )
)

roll_die <- function(n, sides) {
  sample(sides, n, replace = TRUE)
}

server <- function(input, output) {
  output$rolls <- renderText(
    roll_die(input$n, as.numeric(input$sides))
  )
}
runApp(shinyApp(ui, server))
