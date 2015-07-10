library(ggvis)
data("mpg", package = "ggplot2")

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths(
    span = input_slider(0.2, 1)
  )


mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths(stroke := input_select(c("red", "green", "blue")))

mpg %>%
  ggvis(~displ) %>%
  layer_densities(adjust = input_slider(0.1, 5))


# Mapping variables -------------------------------------------------------

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points(fill = input_select(names(mpg)))

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points(fill = input_select(names(mpg), map = as.name))


# Other interactives ------------------------------------------------------

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths(span = waggle(0.2, 1))

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths(span = up_down(0.2, 1))

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points(
    size := left_right(50, 1000),
    opacity := up_down(0, 1)
  )
