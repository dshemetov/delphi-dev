# delphi-dev

Some dev scripts I use for Delphi work.
This README.md contains a few useful recipes.

## API Calls

A few sample API calls to help get started

- Old style: https://delphi.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signals=confirmed_7dav_incidence_num&time_type=day&time_values=20220104-20220106,20220101,20220102&geo_type=state&geo_values=ca
- New style: https://delphi.cmu.edu/epidata/covidcast/?signal=jhu-csse:confirmed_7dav_incidence_num&time=day:20220104-20220106,20220101,20220102;day:20220104-20220107&geo=state:ca
