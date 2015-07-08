library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

library(nycflights13)

# Minor fixes for the included data
weather <- read_csv("weather.csv", col_types = list(
  date = col_datetime("%Y-%m-%d %H:%M:%S"),
  precip = col_double(),
  visib = col_double()
)) %>% mutate(
  temp = (temp - 32) * 5 / 9,
  dewp = (dewp - 32) * 5 / 9
)

# Filter ------------------------------------------------------------------

# Just prints out results
filter(flights, dest %in% c("IAH", "HOU"))
# The original is unchanged:
flights

# To create a new variable use <-
houston <- filter(flights, dest %in% c("IAH", "HOU"))
houston

# BE CAREFUL!
# flights <- filter(flights, dest %in% c("IAH", "HOU"))

filter(flights, dest %in% c("SFO", "OAK"))filter(flights, dest == "SFO" | dest == "OAK")
# Not this!
# filter(flights, dest == "SFO" | "OAK")

filter(flights, month == 1)

filter(flights, hour >= 0 & hour <= 5)
filter(flights, hour >= 0, hour <= 5)
filter(flights, hour <= 5 | hour >= 22)

filter(flights, arr_delay > 2 * dep_delay)


# Select ------------------------------------------------------------------

select(flights, arr_delay, dep_delay)
select(flights, c(arr_delay, dep_delay))
select(flights, dep_delay, dep_delay + 2)
select(flights, ends_with("delay"))
select(flights, contains("delay"))


# Arrange -----------------------------------------------------------------

arrange(flights, month, day, hour, minute)

arrange(flights, desc(dep_delay))
arrange(flights, desc(arr_delay))

arrange(flights, desc(dep_delay - arr_delay))


# Mutate ------------------------------------------------------------------

flights <- mutate(flights,
  speed = distance / (air_time / 60))
arrange(flights, desc(speed))

View(mutate(flights, delta = dep_delay - arr_delay))

mutate(flights,
  hour = dep_time %/% 100,
  minute = dep_time %% 100)

# Grouped summaries -------------------------------------------------------

by_date <- group_by(flights, month, day)
by_hour <- group_by(flights, month, day, hour)
by_plane <- group_by(flights, tailnum)
by_dest <- group_by(flights, dest)

x <- c(1, 4, 4, 7, 10)



by_date <- group_by(flights, date)
delays <- summarise(by_date,
  mean = mean(dep_delay, na.rm = TRUE),
  median = median(dep_delay, na.rm = TRUE),
  q75 = quantile(dep_delay, 0.75, na.rm = TRUE),
  over_15 = mean(dep_delay > 15, na.rm = TRUE),
  over_30 = mean(dep_delay > 30, na.rm = TRUE),
  over_60 = mean(dep_delay > 60, na.rm = TRUE)
)



# NAs ---------------------------------------------------------------------

# NAs are tricky!
NA + 5
10 * NA

10 < NA
10 == NA
NA == NA
is.na(NA)

mean(c(10, 20, NA))
mean(c(10, 20, NA), na.rm = TRUE)

# Data pipelines ----------------------------------------------------------

flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(delay))

delays <- flights %>%
  mutate(time = hour + minute / 60) %>%
  group_by(time) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>%
  filter(time > 5, time < 20)

flights %>%
  group_by(dest) %>%
  summarise(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>%
  arrange(desc(arr_delay))

flights %>%
  group_by(carrier, flight, dest) %>%
  tally(sort = TRUE) %>% # Save some typing
  filter(n == 365)

# Slightly different answer
flights %>%
  group_by(carrier, flight) %>%
  filter(n() == 365)

per_hour <- flights %>%
  mutate(time = hour + minute / 60) %>%
  group_by(time) %>%
  summarise(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

qplot(time, arr_delay, data = per_hour)
qplot(time, arr_delay, data = per_hour, size = n) + scale_size_area()
qplot(time, arr_delay, data = filter(per_hour, n > 30), size = n) + scale_size_area()

ggplot(filter(per_hour, n > 30), aes(time, arr_delay)) +
  geom_vline(xintercept = 5:24, colour = "white", size = 2) +
  geom_point()


# Two table verbs ---------------------------------------------------------

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
delays <- delays %>% left_join(airports, c("dest" = "faa"))
qplot(lon, lat, data = delays, size = n, colour = arr_delay)
qplot(lon, lat, data = delays, size = n, colour = arr_delay) +
  scale_size_area()



hourly_delay <- flights %>%
  group_by(origin, month, day, hour) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(
    delay = mean(dep_delay),
    n = n()
  ) %>%
  filter(n > 10)

delay_weather <- hourly_delay %>%
  inner_join(weather) %>%
  filter(wind_speed < 1000)

anti_join(hourly_delay, weather)
anti_join(weather, hourly_delay)

qplot(temp, delay, data = delay_weather)

qplot(wind_speed, delay, data = delay_weather)

qplot(wind_gust, delay, data = delay_weather)
qplot(wind_gust, delay, data = delay_weather) + geom_smooth()
qplot(wind_gust, delay, data = delay_weather, geom = "boxplot", group = wind_gust)
