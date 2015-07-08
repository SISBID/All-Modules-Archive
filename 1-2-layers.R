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
  geom_point(alpha = 1/10)
ggplot(diamonds, aes(carat, price)) +
  geom_point(shape = 1)
ggplot(diamonds, aes(carat, price)) +
  geom_point(size = 0.1)


# Conditional summaries ---------------------------------------------------

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point() +
  geom_smooth()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_boxplot()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_boxplot(aes(group = plyr::round_any(log10(carat), 0.1)))

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_violin(aes(group = plyr::round_any(log10(carat), 0.1)))

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


# Comparisons -------------------------------------------------------------

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_point(aes(colour = color))

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  facet_wrap(~color)

# Annotations can be very useful!
coef(lm(log10(price) ~ log10(carat), data = diamonds))

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d() +
  geom_abline(intercept = 3.67, slope = 1.68, colour = "white") +
  facet_wrap(~color)
