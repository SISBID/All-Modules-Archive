library(ggplot2)

# Layer basics ------------------------------------------------------------

# ggplot(diamonds, aes(price, carat))
# ggplot(diamonds)
aes(price, carat)

geom_point()
geom_histogram()

# Warmups ------------------------------------------------------------------

ggplot(diamonds, aes(carat, price)) +
  geom_point()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point()


# Change aesthetics -------------------------------------------------------

ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = "blue"))

ggplot(diamonds, aes(carat, price)) +
  geom_point(colour = "blue")

ggplot(diamonds, aes(carat, price)) +
  geom_point(alpha = 1/20)
ggplot(diamonds, aes(carat, price)) +
  geom_point(shape = 1)
ggplot(diamonds, aes(carat, price)) +
  geom_point(size = 0.1)


# Conditional summaries ---------------------------------------------------

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point() +
  geom_smooth()

ggplot(diamonds, aes(log10(carat), log10(price), colour = cut)) +
  geom_point() +
  geom_smooth()
ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point(aes(colour = cut)) +
  geom_smooth()



ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point() +
  geom_smooth(method = "lm")

mod <- lm(log10(price) ~ log10(carat), data = diamonds)
diamonds$resid <- resid(mod)

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point(aes(colour = resid)) +
  geom_smooth(method = "lm") +
  scale_colour_gradient2()

ggplot(diamonds, aes(log10(carat), resid)) +
  geom_point()


ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_boxplot()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_boxplot(aes(group = plyr::round_any(log10(carat), 0.05)))

plyr::round_any(c(3.232, 5.46, 10.46), 0.1)
plyr::round_any(c(3.232, 5.46, 10.46), 0.25)
plyr::round_any(c(3.232, 5.46, 10.46), 3)

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_violin(aes(group = plyr::round_any(log10(carat), 0.1)), scale = "width")

ggplot(diamonds, aes(1, depth)) +
  geom_boxplot()

ggplot(diamonds, aes(cut, depth)) +
  geom_boxplot()

ggplot(diamonds, aes(depth)) +
  geom_histogram(binwidth = 0.2) +
  xlim(56, 67)

ggplot(diamonds, aes(depth, fill = cut)) +
  geom_histogram(binwidth = 0.2) +
  xlim(56, 67)

ggplot(diamonds, aes(depth)) +
  geom_histogram(binwidth = 0.2) +
  facet_wrap(~cut) +
  xlim(56, 67)

ggplot(diamonds, aes(depth, colour = cut)) +
  geom_freqpoly(binwidth = 0.2) +
  xlim(56, 67)

ggplot(diamonds, aes(depth, colour = cut)) +
  geom_freqpoly(aes(y = ..density..), binwidth = 0.2) +
  xlim(56, 67)



# Distribution of price ---------------------------------------------------

ggplot(diamonds, aes(price)) +
  geom_histogram()

ggplot(diamonds, aes(log10(price))) +
  geom_histogram()
ggplot(diamonds, aes(log10(price))) +
  geom_histogram(binwidth = 0.05)

ggplot(diamonds, aes(log10(price))) +
  geom_histogram(aes(fill = cut), binwidth = 0.05)
ggplot(diamonds, aes(log10(price))) +
  geom_freqpoly(aes(colour = cut), binwidth = 0.05)
ggplot(diamonds, aes(log10(price))) +
  geom_freqpoly(aes(y = ..density.., colour = cut), binwidth = 0.05)
ggplot(diamonds, aes(log10(price))) +
  geom_freqpoly(aes(y = ..density.., colour = cut), binwidth = 0.25)

ggplot(diamonds, aes(cut, log10(price))) +
  geom_violin()

ggplot(diamonds, aes(log10(price))) +
  geom_density(aes(y = ..density.., colour = cut))


# Joint summaries ---------------------------------------------------------

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()
ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_hex()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_density2d()

# Comparisons -------------------------------------------------------------

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point(aes(colour = color))
ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point() +
  facet_wrap(~ color)
ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  facet_wrap(~ color)

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  facet_wrap(~color)

# Annotations can be very useful!
coef(lm(log10(price) ~ log10(carat), data = diamonds))

mod <- lm(log10(price) ~ log10(carat), data = diamonds)

grid <- data.frame(
  carat = seq(min(diamonds$carat), max(diamonds$carat), length = 10)
)
grid$price <- 10 ^ predict(mod, newdata = grid)
grid

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  geom_line(data = grid, colour = "white", size = 2) +
  facet_wrap(~color)

mod_coef <- coef(mod)
ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  geom_abline(intercept = mod_coef[1], slope = mod_coef[2], colour = "white") +
  facet_wrap(~color)


diamonds$color <- factor(diamonds$color, ordered = F)
anova(lm(log10(price) ~ log10(carat) * color, data = diamonds))

