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
      selectInput("gender", "What is your gender", c("Male", "Female", "Other")),
      checkboxInput("like_r", "Do you like R?")
    ),
    mainPanel(
      textOutput("description")
    )
  )
)

description <- function(name, age, gender, likes_r) {
  gender_desc <- switch(gender,
    Male = "man",
    Female = "female",
    Other = "person"
  )

  paste0(name, " is a ", age, " year old ", gender_desc,
    " who ", if (!likes_r) "doesn't like" else "likes", " R")
}


server <- function(input, output) {
  output$description <- renderText(
    description(input$name, input$age, input$gender, input$like_r)
  )
}

runApp(shinyApp(ui, server))
