library(fpp3)

global_economy |>
  filter(Country == "Australia") |>
  autoplot(GDP/Population) +
  labs(title= "GDP per capita", y = "$US")

global_economy |>
  filter(Country == "United States") |>
  autoplot(GDP/Population) +
  labs(title= "GDP per capita", y = "$US")

global_economy %>% tibble() %>% select(Year) %>% distinct() %>% max()


print_retail <- aus_retail |>
  filter(Industry == "Newspaper and book retailing") |>
  group_by(Industry) |>
  index_by(Year = year(Month)) |>
  summarise(Turnover = sum(Turnover))
aus_economy <- global_economy |>
  filter(Code == "AUS")
print_retail |>
  left_join(aus_economy, by = "Year") |>
  mutate(Adjusted_turnover = Turnover / CPI * 100) |>
  pivot_longer(c(Turnover, Adjusted_turnover),
               values_to = "Turnover") |>
  mutate(name = factor(name,
         levels=c("Turnover","Adjusted_turnover"))) |>
  ggplot(aes(x = Year, y = Turnover)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y") +
  labs(title = "Turnover: Australian print media industry",
       y = "$AU")


us_retail_employment |>
  model(
    STL(Employed ~ trend(window = 7) +
                   season(window = "periodic"),
    robust = TRUE)) |>
  components() |>
  autoplot()


# Experiment: Apply STL to COVID data
library(epidatr)
data <- covidcast("hhs", "confirmed_admissions_covid_1d", "state", "day", "ca", epirange(20200101, 20240101)) %>%
    fetch
data_ca <- data %>%
    as_tsibble(index = "time_value") %>%
    select(-direction) %>%
    filter(time_value >= "2021-01-01") %>%
    filter(time_value <= "2023-06-01")

data_ca %>% tsibble::fill_gaps()

data_ca %>% model(
    STL(value)) %>%
    components() %>%
    autoplot()


# Experiment: Apply STL to flu data
library(epidatr)
data <- fluview(regions = "nat", epiweeks = epirange(200001, 202201)) %>% fetch()
data_ca <- data %>%
    mutate(epiweek = yearweek(data$epiweek)) %>%
    as_tsibble(index = "epiweek") %>% tsibble::fill_gaps() %>%
    filter(epiweek > yearweek("2002W38"))

data_ca[which(is.na(data_ca$num_ili)),] %>% tail

data_ca %>% model(
    STL(num_ili,
        robust = TRUE)) %>%
    components() %>%
    autoplot()

# How to make use of this in forecasting?
# - One way is to forecast on the components, after doing STL
# - Another way is to include time of year as a feature into the model
