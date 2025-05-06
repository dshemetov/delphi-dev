library(fpp3)
library(tsibble)

y <- tsibble(
  Year = 2015:2019,
  Observation = c(123, 39, 78, 52, 110),
  index = Year
)

olympic_running %>% distinct(Sex)

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC / 1e6) -> a10

prison <- readr::read_csv("https://OTexts.com/fpp3/extrafiles/prison_population.csv")
prison <- prison |>
  mutate(Quarter = yearquarter(Date)) |>
  select(-Date) |>
  as_tsibble(key = c(State, Gender, Legal, Indigenous),
             index = Quarter)
prison

melsyd_economy <- ansett |>
  filter(Airports == "MEL-SYD", Class == "Economy") |>
  mutate(Passengers = Passengers/1000)
autoplot(melsyd_economy, Passengers) +
  labs(title = "Ansett airlines economy class",
       subtitle = "Melbourne-Sydney",
       y = "Passengers ('000)")

ansett

autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

a10 |>
  gg_season(Cost, labels = "both") +
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")


# Experiment: Season plot of covidcast data
library(epidatr)
data <- covidcast("hhs", "confirmed_admissions_covid_1d", "state", "day", "*", epirange(20200101, 20240101)) %>% fetch

data %>% filter(geo_value %in% c("ca")) %>% as_tsibble(key = c("geo_value"), index = "time_value") %>% tsibble::fill_gaps() %>% gg_season(value, labels = "both")

ndata <- covidcast("hhs", "confirmed_admissions_covid_1d", "nation", "day", "*", epirange(20200101, 20240101)) %>% fetch

# Experiment: Lag plot of covidcast data
ndata %>% as_tsibble(key = c("geo_value"), index = "time_value") %>% tsibble::fill_gaps() %>% gg_lag(value, lags=c(0, 7, 14, 21, 60), geom="point", period="year") + theme(legend.position = "none")

ndata <- covidcast("hhs", "confirmed_admissions_covid_1d", "nation", "day", "*", epirange(20200101, 20240101)) %>% fetch


# Exercises
aus_production
autoplot(aus_production, Bricks)
gg_season(aus_production, Bricks)
gg_subseries(aus_production, Bricks)
pelt
autoplot(pelt, Lynx)
gg_season(pelt, Lynx, period="12Y")
gafa_stock
autoplot(gafa_stock, Close)
vic_elec
autoplot(vic_elec, Demand)
View(pelt)

# pak::pkg_install("USgas")
library(USgas)
us_total %>% as_tsibble(index="year", key="state") %>%
    filter(state %in% c("Maine", "Vermon", "New Hampshire", "Massachusetts", "Connecticut", "Rhode Island")) %>% 
    autoplot(y)
