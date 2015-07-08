library(shiny)

ui <- fluidPage(
  sliderInput("num1", "Pick a number", 1, 10, value = 5),
  sliderInput("num2", "Pick another number", 1, 10, value = 5),
  sliderInput("num3", "And one more", 1, 10, value = 5),
  p("The sum of 1 and 2 is :", textOutput("sum12", inline = TRUE)),
  p("The sum of 1 and 2 and 3 is :", textOutput("sum123", inline = TRUE))
)

server <- function(input, output, session) {
  sum12 <- reactive({
    message("sum12 = num1 + num2 =", input$num1 + input$num2)
    input$num1 + input$num2
  })
  sum123 <- reactive({
    message("sum123 = sum12 + num3 = ", sum12() + input$num3)
    sum12() + input$num3
  })

  observe({
    sum12()
    sum123()
    message("---------------------")
  })

  output$sum12 <- renderText(sum12())
  output$sum123 <- renderText(sum123())
}

runApp(shinyApp(ui, server))
