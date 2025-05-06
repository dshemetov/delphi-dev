library(fpp3)
library(httpgd)

gdppc <- global_economy |>
  mutate(GDP_per_capita = GDP / Population)

gdppc |>
  filter(Country == "Sweden") |>
  autoplot(GDP_per_capita) +
  labs(y = "$US", title = "GDP per capita for Sweden")

fit <- gdppc |>
  model(trend_model = TSLM(GDP_per_capita ~ trend()))

fit

fit |> forecast(h = "3 years")

fit |>
  forecast(h = "3 years") |>
  filter(Country == "Sweden") |>
  autoplot(gdppc) +
  labs(y = "$US", title = "GDP per capita for Sweden")


bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)

bricks |>
  model(MEAN(Bricks)) |>
  forecast(h = "3 years") |>
  autoplot(bricks)

bricks |>
  model(NAIVE(Bricks)) |>
  forecast(h = "3 years") |>
  autoplot(bricks)

bricks |>
  model(SNAIVE(Bricks)) |>
  forecast(h = "3 years") |>
  autoplot(bricks)

bricks |>
  model(RW(Bricks ~ drift())) |>
  forecast(h = "3 years") |>
  autoplot(bricks)


# Set training data from 1992 to 2006
train <- aus_production |>
  filter_index("1992 Q1" ~ "2006 Q4")
# Fit the models
beer_fit <- train |>
  model(
    Mean = MEAN(Beer),
    `Naïve` = NAIVE(Beer),
    `Seasonal naïve` = SNAIVE(Beer)
  )
# Generate forecasts for 14 quarters
beer_fc <- beer_fit |> forecast(h = 14)
# Plot forecasts against actual values
beer_fc |>
  autoplot(train, level = NULL) +
  autolayer(
    filter_index(aus_production, "2007 Q1" ~ .),
    colour = "black"
  ) +
  labs(
    y = "Megalitres",
    title = "Forecasts for quarterly beer production"
  ) +
  guides(colour = guide_legend(title = "Forecast"))


google_stock <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) >= 2015) |>
  mutate(day = row_number()) |>
  update_tsibble(index = day, regular = TRUE)
# Filter the year of interest
google_2015 <- google_stock |> filter(year(Date) == 2015)


aug <- google_2015 |>
  model(NAIVE(Close)) |>
  augment()

autoplot(aug, .innov) +
  labs(
    y = "$US",
    title = "Residuals from the naïve method"
  )

aug |>
  ggplot(aes(x = .innov)) +
  geom_histogram() +
  labs(title = "Histogram of residuals")

aug |>
  ACF(.innov) |>
  autoplot() +
  labs(title = "Residuals from the naïve method")
