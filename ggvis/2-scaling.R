library(ggvis)
data("mpg", package = "ggplot2")


mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points(fill = "red")


mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points() %>%
  layer_model_predictions(model = "lm",
    stroke = "lm") %>%
  layer_smooths(stroke = "loess")

mpg %>%
  ggvis(~displ, ~hwy) %>%
  layer_points(fill := "red")


# Sometimes the data is already scaled
df <- data.frame(
  x = 1:3,
  y = 1:3,
  col = c("red", "green", "blue")
)

ggvis(df, ~x, ~y, fill = ~col)
ggvis(df, ~x, ~y, fill := ~col)


# Variables ---------------------------------------------------------------

df <- data.frame(
  x = 1:3,
  y = 1:3
)

xvar <- ~x
yvar <- ~y
ggvis(df, xvar, yvar)

# https://github.com/rstudio/ggvis/issues/416
xvar <- quote(x)
yvar <- quote(y)
ggvis(df, xvar, yvar)

var <- "x"
eval(substitute(~ x, list(x = as.name(var))))
# See
# http://adv-r.had.co.nz/Computing-on-the-language.html
# http://adv-r.had.co.nz/Expressions.html
