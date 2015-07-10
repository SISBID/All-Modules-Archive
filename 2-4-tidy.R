library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

# Variable names in columns -----------------------------------------------

pew <- read_csv("tidy/pew.csv")
pew %>%
  gather(income, count, -religion)

pew %>%
  gather(income, count, -religion) %>%
  group_by(religion) %>%
  mutate(prop = count / sum(count)) %>%
  ggplot(aes(income, prop)) +
  geom_line(aes(group = religion)) +
  facet_wrap(~religion)


# Multiple variables in one column ----------------------------------------

tb <- read_csv("tidy/tb.csv")
tb_tidy <- tb %>%
  gather(demographic, cases, m_04:f_u, na.rm = TRUE) %>%
  separate(demographic, c("sex", "age"), "_") %>%
  rename(country = iso2) %>%
  arrange(country, year, sex, age)

pop <- read_csv("tidy/population.csv")
pop_tidy <- pop %>%
  gather(demographic, population, m_04:f_65, na.rm = TRUE) %>%
  separate(demographic, c("sex", "age")) %>%
  rename(country = iso2) %>%
  arrange(country, year, sex, age)

View(anti_join(tb_tidy, pop_tidy))

# Highest rate of TB
tb_tidy %>%
  left_join(pop_tidy) %>%
  mutate(rate = cases / population) %>%
  arrange(desc(rate))

# Variable names in cells -------------------------------------------------

weather <- read_tsv("tidy/weather.txt", na = ".")
weather %>%
  gather(day, value, `1`:`31`, na.rm = TRUE) %>%
  spread(element, value) %>%
  mutate(
    tmin = as.numeric(tmin) / 10,
    tmax = as.numeric(tmax) / 10,
    t_range = tmax - tmin
  )

titanic2 <- read_csv("tidy/titanic2.csv")
titanic2 %>%
  gather(gender, n, male:female) %>%
  spread(fate, n) %>%
  mutate(rate = survived / (survived + perished))

titanic2 %>%
  gather(gender, n, male:female) %>%
  spread(fate, n) %>%
  group_by(class, gender) %>%
  summarise(perished = sum(perished), survived = sum(survived)) %>%
  mutate(rate = survived / (survived + perished))
