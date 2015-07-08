# install.packages("shiny")
library(shiny)

ui <- fluidPage("Hello World")
server <- function(input, output) {}

runApp(shinyApp(ui, server))
