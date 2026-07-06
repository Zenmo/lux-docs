# Domestic hot water tapping profiles

LUX uses domestic hot water (DHW) tapping profiles to simulate the hot water consumption of households. The profiles are annual time series with a 15 minute resolution (35,040 values), matching the default timestep of the simulation. Profiles are available for household sizes of 1 to 5 persons, with 20 stochastic variants per household size, so that not every household of the same size draws hot water at exactly the same moments. This page describes how these profiles were generated, how they were converted to model input, and which assumptions were made along the way.

## Generation with DHWcalc

The profiles were generated with [DHWcalc](https://www.uni-kassel.de/maschinenbau/en/institute/thermische-energietechnik/fachgebiete/solar-und-anlagentechnik/downloads) version 2.02b, a tool developed by Ulrike Jordan and Klaus Vajen at the Universität Kassel within the IEA Solar Heating and Cooling Programme, Task 26 (Solar Combisystems). DHWcalc distributes DHW draw-off events throughout the year on a statistical basis, using the cumulated frequency method: the probability that a draw-off occurs at a given time is described by the product of probability functions for the time of day, the day of the week, the season and holiday periods. A random generator then places individual draw-off events (e.g. short taps, showers, baths) over the year according to this probability function.

The executable, its manual and the settings used can be found in the `data_Generic` repository under `WeatherAndEPEX-data/DHW/DHW-calc`.

### Settings used

All profiles were generated as *single family house* profiles with a total duration of 365 days (starting on day 1 of the year, a Monday), a time step duration of 15 minutes and European daylight saving time applied. The four default draw-off categories of DHWcalc were used, which represent small draw-offs (e.g. hand washing), medium draw-offs (e.g. dish washing), showers and baths:

| Category | Mean flow rate (l/h) | Duration | Portion of daily volume | Sigma (l/h) |
|----------|---------------------|----------|------------------------|-------------|
| 1 – small draw-offs | 4 | 15 min | 14 % | 8 |
| 2 – medium draw-offs | 24 | 15 min | 36 % | 8 |
| 3 – bath | 560 | 15 min | 10 % | 8 |
| 4 – shower | 160 | 15 min | 40 % | 8 |

The minimum and maximum flow rates were 1 l/h and 1,200 l/h respectively. Note that because the time step is 15 minutes, the draw-off duration is also 15 minutes (draw-off durations must be integer multiples of the time step).

For the probability of draw-offs during the day, the DHW standard step function distributions for weekdays and weekend-days were used with their default values:

| Weekdays | Share of daily volume | Weekend-days | Share of daily volume |
|--------------|------|--------------|--------|
| 22:00–06:30 | 2 % | 23:00–07:00 | 3.8 % |
| 06:30–07:30 | 50 % | 07:00–09:00 | 47.5 % |
| 07:30–12:00 | 6 % | 09:00–15:00 | 7.1 % |
| 12:00–13:00 | 16 % | 15:00–17:00 | 23.8 % |
| 13:00–18:00 | 6 % | 17:00–20:00 | 3.6 % |
| 18:00–22:00 | 20 % | 20:00–23:00 | 14.3 % |

The ratio of the mean daily draw-off volume tapped on weekend-days compared to weekdays was set to 120 %.

For the seasonal variation, the *step function for months* option was selected with the default monthly values, which give a higher hot water consumption in winter than in summer:

| Month | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
|-------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| Probability | 109 % | 110 % | 109 % | 105 % | 100 % | 95 % | 91 % | 90 % | 91 % | 95 % | 100 % | 105 % |

No holiday periods were defined.

### Daily draw-off volume and profile variants

The total mean daily draw-off volume is assumed to be **40 litres per person per day**: 40 l/day for a 1-person household, 80 l/day for 2 persons, 120 l/day for 3 persons, 160 l/day for 4 persons and 200 l/day for 5 persons.

To obtain multiple different profiles per household size, DHWcalc's *series of load profiles* function was used. DHWcalc initialises its random generator with the product of the total mean daily draw-off volume and the draw-off category number, so generating the same profile twice with identical settings yields identical results. By slightly varying the mean daily draw-off volume, a series of profiles with nearly the same total consumption but different random draw-off distributions is obtained. For each household size a series range of ±1 l/day around the nominal volume was set with a step size of 0.1 l/day, e.g. 39.0, 39.1, …, 41.0 l/day for the 1-person household. This yields 21 profiles per household size, of which the first 20 are used in the model.

The raw DHWcalc output can be found in the `data_Generic` repository under `WeatherAndEPEX-data/DHW/DHW_profiles`, in the folders `1p_DHW` through `5p_DHW`. Each generated profile has its own subfolder (e.g. `1p_DHW_1`) containing four files:

* `*_DHW.txt`: the profile itself, one mean flow rate value in litres/hour for each 15 minute time step (35,040 lines).
* `*_Vdot.txt`: a list of the individual draw-off events (flow rate and time step number).
* `*_sum.txt`: daily and hourly sums of the draw-off volumes in litres.
* `*_log.txt`: a log of all input settings used to generate that specific profile. This file documents the exact assumptions per generated profile.

## Conversion to model input

The individual profiles are combined into the Excel workbook `dhw_profiles.xlsx` (in `WeatherAndEPEX-data/DHW/DHW_profiles`) by the script `create_dhw_excel.py` in the same folder. The profile columns are named `DHW<variant>_<size>p`, e.g. `DHW3_2p` for the third variant of the 2-person profile.

### From flow rate to volume

The values in the DHWcalc output files are mean flow rates in litres/hour per time step, not volumes. An extra processing step is therefore needed: each value is divided by 4 to convert the flow rate sustained over a quarter of an hour into the tapped volume in litres per 15 minute time step. The resulting volumes are stored in the worksheet `dhw_profiles_literquarterhour`.

### From volume to energy

The LUX model loads DHW demand as energy (kWh) per time step, so the volumes have to be converted to the energy needed to heat the tapped water. The energy per time step is calculated as:

```
E [kWh] = V [litres] × cp [kJ/(kg·K)] × (T_dhw − T_cold) [K] / 3600
```

with 1 litre of water taken as 1 kg and a specific heat capacity cp of 4.186 kJ/(kg·K). The following assumptions are made for the temperatures:

* **The hot water tapping temperature T_dhw is 60 °C.** This is the typical storage/supply temperature of domestic hot water systems, required to prevent legionella growth.
* **The cold water inlet temperature T_cold equals the soil temperature at 100 cm depth.** Drinking water mains in the Netherlands are buried at roughly this depth, so the water entering the dwelling is assumed to have this temperature. Soil temperature data was obtained from [KNMI](https://www.knmi.nl/nederland-nu/klimatologie/daggegevens) for station 260 (De Bilt) and is stored in `bodemtemps_260.txt`. The file contains soil temperatures at 5, 10, 20, 50 and 100 cm depth with a 6-hour resolution; the 100 cm series (column TB5) of the year 1981 is linearly interpolated to the 15 minute resolution of the profiles.

Because the cold water inlet temperature varies over the year (roughly 4 °C in late winter to 16 °C in late summer at 100 cm depth), the same tapped volume requires more energy in winter than in summer. Combined with the seasonal step function used in DHWcalc, this gives the DHW energy demand a realistic seasonal pattern.

The resulting energy profiles are stored in the worksheet `dhw_profiles_kwh`, which is the input loaded into the model. The intermediate soil temperature data is kept in the worksheet `bodemtemps`. With these assumptions the annual DHW energy demand amounts to roughly 0.8 MWh for a 1-person household up to roughly 4.2 MWh for a 5-person household.

## Summary of assumptions

* Mean daily draw-off volume of 40 litres per person per day (varied by at most ±1 l/day to create stochastic variants).
* Hot water consumption follows the DHWcalc standard step function distributions during the day, with a morning peak on both weekdays and weekend-days.
* Weekend-days have 20 % more consumption than weekdays.
* Consumption is 9–10 % above average in winter months and 9–10 % below average in summer months (DHWcalc default monthly step function).
* No holiday periods (nobody is ever away from home).
* Draw-offs are statistically distributed; the profiles are stochastic realisations, not measured data.
* Hot water is tapped at 60 °C.
* Cold water enters at the soil temperature at 100 cm depth (KNMI station De Bilt, year 1981).
* Heating the water is assumed lossless in this conversion; storage and distribution losses are not included in the tapping profiles.
