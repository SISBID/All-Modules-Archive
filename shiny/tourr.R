library(tourr)
library(ggvis)
library(shiny)

fps <- 30
mat <- rescale(as.matrix(flea[1:6]))

ui <- fluidPage(
  sliderInput("aps", "Angle per second (radians)", 0.5, 5, value = 2),
  checkboxInput("pause", "Paused"),
  ggvisOutput("tour")
)

server <- function(input, output) {
  tour <- new_tour(mat, grand_tour())

  proj_mat <- reactive({
    if (is.null(input$pause) || is.null(input$aps)) {
      return(basis_init(6, 2))
    }

    if (!input$pause)
      invalidateLater(1000 / fps, NULL)
    step <- tour(isolate(input$aps) / fps)
    step$proj
  })

  proj_data <- reactive({
    data.frame(center(mat %*% proj_mat()), species = flea$species)
  })

  proj_data %>% ggvis(~X1, ~X2, fill = ~species) %>%
    layer_points() %>%
    scale_numeric("x", domain = c(-1, 1)) %>%
    scale_numeric("y", domain = c(-1, 1)) %>%
    set_options(duration = 0) %>%
    bind_shiny("tour")

}

runApp(shinyApp(ui, server))
