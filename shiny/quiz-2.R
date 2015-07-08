# DON'T LOOK AT ME!

library(shiny)

ui <- fluidPage(
  titlePanel(
    "Who are you?"
  ),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What is your name?"),
      sliderInput("age", "How old are you?", 0, 100, 50),
      selectInput("gender", "What is your gender?", c("Male", "Female", "Other")),
      checkboxInput("like_r", "Do you like R?")
    ),
    mainPanel()
  )
)

runApp(shinyApp(ui, function(input, output) {}))
