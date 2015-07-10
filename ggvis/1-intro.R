library(ggvis)
data("mpg", package = "ggplot2")
data("economics", package = "ggplot2")


# Basic plots -------------------------------------------------------------

ggvis(mpg, x = ~displ, y = ~hwy)
ggvis(mpg, ~displ, ~hwy)

# Other plot types

ggvis(mpg, ~displ)
ggvis(mpg, ~displ, ~hwy)

ggvis(economics, ~date, ~psavert)

ggvis(mpg, ~drv)
ggvis(mpg, ~drv, ~hwy)

# Other visual properties

ggvis(mpg, ~displ, ~hwy, fill = ~class)
ggvis(mpg, ~displ, ~hwy, shape = ~drv)
ggvis(mpg, ~displ, ~hwy, size = ~cty)

ggvis(mpg, ~displ, ~hwy, fill = ~class, shape = ~drv)


# Piping ----------------------------------------------------------------

layer_smooths(
  layer_points(
    ggvis(mpg, ~displ, ~hwy)
  )
)

# Same as

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths()

library(dplyr)

mpg %>%
  filter(year == 1999) %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_smooths()

mpg %>%
  group_by(cyl) %>%
  ggvis(~hwy) %>%
  layer_histograms(fill = ~cyl)

mpg %>%
  group_by(cyl) %>%
  ggvis(~hwy) %>%
  layer_freqpolys(stroke = ~cyl, width = 2)


# Cocaine -----------------------------------------------------------------

ggvis(cocaine, ~weight, ~price) %>%
  layer_points() %>%
  layer_smooths(stroke = "red")

cocaine %>%
  ggvis(~potency, ~price) %>%
  layer_points()

cocaine %>%
  filter(weight <= 250) %>%
  ggvis(~weight, ~potency) %>%
  layer_points() %>%
  layer_smooths(stroke = "red")

ggvis(cocaine, ~weight, ~price) %>%
  layer_points()
