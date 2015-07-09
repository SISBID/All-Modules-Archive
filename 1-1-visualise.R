# install.packages("ggplot2")

library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

# Minor fixes for the included data
weather <- read_csv("weather.csv", col_types = list(
  date = col_datetime("%Y-%m-%d %H:%M:%S"),
  precip = col_double(),
  visib = col_double()
)) %>% mutate(
  temp = (temp - 32) * 5 / 9,
  dewp = (dewp - 32) * 5 / 9
)

# A data frame has named columns, each column is the same length
weather
str(weather)
View(weather)

# Introduction to data frames --------------------------------------------------

daily <- filter(weather, hour == 12)
jfk <- filter(weather, origin == "JFK")

# Basic graphics ---------------------------------------------------------------
# What is a plot? Mapping between variables and aesthietcs.
# Three most useful graphics are:
# scatterplot, histogram & line chart

ggplot(daily, aes(temp, humid)) +
  geom_point()
ggplot(daily, aes(wind_speed)) +
  geom_histogram()
ggplot(jfk, aes(date, temp)) +
  geom_line()


# Scatterplots ------------------------------------------------------------

ggplot(daily, aes(temp, humid)) + geom_point()
# Add extra properties with shape or colour
ggplot(daily, aes(temp, humid, shape = origin)) +
  geom_point()
ggplot(daily, aes(temp, humid, colour = origin)) +
  geom_point()


# Discrete data
ggplot(daily, aes(wind_dir, wind_speed)) +
  geom_point()
ggplot(daily, aes(wind_dir, wind_speed)) +
  geom_jitter() +
  coord_polar()

# And in the dev version
ggplot(daily, aes(wind_dir, wind_speed)) +
  geom_count()

# Line charts ------------------------------------------------------------------

# Useful when you have a time series
ggplot(daily, aes(date, temp)) +
  geom_point()
ggplot(daily, aes(date, temp)) +
  geom_line()
ggplot(daily, aes(date, temp, group = origin)) +
  geom_line()
ggplot(daily, aes(date, temp, colour = origin)) +
  geom_line()

# Alternative to aesthetics is to use _facetting_
ggplot(daily, aes(date, temp)) +
  geom_line() +
  facet_wrap(~origin)

# Will learn how to do this later
daily <- daily %>%
  group_by(date) %>%
  mutate(temp_diff = temp - mean(temp))
ggplot(daily, aes(date, temp_diff)) +
  geom_line(aes(colour = origin))


jfk$yday <- lubridate::yday(jfk$date)

ggplot(jfk, aes(hour, humid)) +
  geom_line(aes(group = yday)) +
  facet_wrap(~yday)

ggplot(jfk, aes(hour, humid)) +
  stat_summary(fun.ymin = min, fun.ymax = max, geom = "ribbon") +
  facet_wrap(~month)


ggplot(jfk, aes(hour, temp)) +
  geom_line()
ggplot(jfk, aes(hour, temp)) +
  geom_line(aes(group = interaction(month, day)))
ggplot(jfk, aes(hour, temp)) +
  geom_line(aes(group = day)) +
  facet_wrap(~month)


# Histograms -------------------------------------------------------------------

ggplot(daily, aes(wind_speed)) + geom_histogram()
ggplot(daily, aes(wind_speed)) +
  geom_histogram(binwidth = 1)

ggplot(daily, aes(wind_dir)) + geom_histogram()
ggplot(daily, aes(wind_dir)) + geom_histogram()

ggplot(daily, aes(wind_dir)) +
  geom_histogram(binwidth = 10)

ggplot(daily, aes(precip)) + geom_histogram()

ggplot(filter(weather, precip > 0), aes(precip)) +
  geom_histogram(binwidth = 0.01)
# ALWAYS EXPERIMENT WITH THE BIN WIDTH!

# What's strange about wind speed?
ggplot(daily, aes(wind_speed)) + geom_histogram()
ggplot(daily, aes(wind_speed)) + geom_histogram(binwidth = 1)
ggplot(daily, aes(wind_speed)) + geom_histogram(binwidth = 0.5)
ggplot(daily, aes(wind_speed)) + geom_histogram(binwidth = 0.1)

resolution(daily$wind_speed)
ggplot(daily, aes(wind_speed)) + geom_histogram(binwidth = 1.15)
# What's the significance of 1.15?
