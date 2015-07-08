library(shiny)

ui <- fluidPage(
  titlePanel("Dice roller"),
  sidebarPanel(
    numericInput("n", "How many dice would you like to roll?", 10, min = 1),
    selectInput("sides", "How many sides?", c(6, 12, 20))
  ),
  mainPanel(
    textOutput("rolls"),
    plotOutput("dist"),
    tableOutput("summary")
  )
)
roll_die <- function(n, sides) {
  sample(sides, n, replace = TRUE)
}

server1 <- function(input, output) {
  rolls <- roll_die(input$n, as.numeric(input$sides))

  output$rolls <- renderText(rolls)
  output$dist <- renderPlot(plot(table(rolls)))
  output$summary <- renderTable(table(rolls))
}

server2 <- function(input, output) {
  rolls <- function() {
    roll_die(input$n, as.numeric(input$sides))
  }

  output$rolls <- renderText(rolls())
  output$dist <- renderPlot(plot(table(rolls())))
  output$summary <- renderTable(table(rolls()))
}

server3 <- function(input, output) {
  rolls <- reactive({
    roll_die(input$n, as.numeric(input$sides))
  })

  output$rolls <- renderText(rolls())
  output$dist <- renderPlot(plot(table(rolls())))
  output$summary <- renderTable(table(rolls()))
}

server4 <- function(input, output) {
  rolls <- reactive({
    roll_die(input$n, as.numeric(input$sides))
  })
  rolls_table <- reactive(table(rolls()))

  output$rolls <- renderText(rolls())
  output$dist <- renderPlot(plot(rolls_table()))
  output$summary <- renderTable(rolls_table())
}


# runApp(shinyApp(ui, server1))
# runApp(shinyApp(ui, server2))
# runApp(shinyApp(ui, server3))
