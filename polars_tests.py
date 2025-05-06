# %%
import polars as pl
from epidatpy import EpiDataContext, EpiRange


epidata = EpiDataContext(use_cache=True, cache_max_age_days=7)
data = epidata.pub_covidcast(
    data_source="jhu-csse",
    signals="confirmed_cumulative_num",
    geo_type="county",
    time_type="day",
    geo_values="01001",
    time_values=EpiRange(20200101, 20240401),
).df()

# %% Load data into Polars and get the diffed series and the moving average of the diffed series
# Create a DataFrame with the specified schema and parse dates
pldf = pl.from_pandas(data)
# Get the incidence series from cumulative
pldf = pldf.with_columns(value=pl.col("value").diff().over(["source", "signal", "geo_value"]))
# Compute 3 new columns over a rolling window of 7 days (by default the window
# is ahead of the current row, so offset needs to be set)
pldf = pldf.join(
    pldf.group_by_dynamic(
        "time_value", every="1d", period="7d", offset="-7d", group_by=["source", "signal", "geo_value"]
    ).agg(value_smooth=pl.col("value").mean(), issue=pl.col("issue").max(), lag=pl.col("lag").max()),
    on=["source", "signal", "geo_value", "time_value"],
    how="full",
    coalesce=True,
).with_columns(direction=pl.lit(None))
pldf

# %% Using rolling_mean is not supported for series with null values at the moment
pldf.with_columns(pl.col("value").rolling_mean_by("time_value", "7d"))

# %% Plot the diffed series and the moving average of the diffed series
pldf.filter((pl.col("geo_value") == "1001")).to_pandas().set_index("time_value")[["value", "value_smooth"]].plot()
