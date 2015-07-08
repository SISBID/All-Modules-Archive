library(shiny)

ui <- fluidPage(
  h1("This is a title"),
  p("It is ", strong("important"), " to understand the basics of HTML."),
  p("A link has an ", a(href = "http://shiny.rstudio.com", " href attribute"), ".")
)
runApp(shinyApp(ui, function(input, output) {}))
