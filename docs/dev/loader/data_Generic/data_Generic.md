# data_Generic

The [data_Generic repository](https://github.com/Zenmo/data_Generic) contains all generic, non-project-specific input data used by LUX models. Where project repositories hold the sensitive, location-specific data of a particular neighbourhood or business park, data_Generic holds the datasets that are the same for every model: consumption and production profiles, weather data, market prices, emission factors and cost figures. Most of it applies to the Netherlands. The repository contains both the final input files that are read by the loader and the raw source data and scripts used to produce them, so that every input can be traced back to its origin.

## Input files in the repository root

The files in the root of the repository are the ones loaded into the models:

* `db_profiles.xlsx`: the main profile workbook, with normalized production and demand profiles per year (2023, 2024, 2025) at hourly and quarter-hourly resolution. It contains normalized wind and solar production (for several locations and panel orientations), ambient temperature, day-ahead electricity prices, and normalized demand profiles for households (electricity, hot water, cooking), buildings, industry and logistics. The `Documentation` worksheet inside the workbook defines each profile column.
* `DHWProfiles_data.xlsx`: stochastic domestic hot water tapping profiles in kWh per quarter-hour for household sizes of 1 to 5 persons, 20 variants each. How these were generated is described on the [Domestic hot water tapping profiles](Domestic hot water tapping profiles.md) page.
* `ChargerProfile_data.xlsx` and `Laadprofielen_standaard.xlsx`: electric vehicle charging profiles.
* `AlbatrossProcessedVehicleTrips.csv`: passenger vehicle trip patterns (departure time, arrival time and distance per trip) derived from the Albatross activity-based transport model, used to simulate driving and charging behaviour of household EVs.
* `inputTruckTripPatterns.csv`: trip patterns for trucks, analogous to the vehicle trips above, used for logistics fleets.
* `inputECookerPatterns.csv`: electric cooking sessions (start, end and power per session), used to simulate cooking demand.
* `data_households_PBL_2023.xlsx`: reference energy consumption of Dutch households from PBL (Planbureau voor de Leefomgeving), used for space heating demand, number of residents, cooking and domestic hot water consumption.

## Subfolders

### data_ProjectTemplate

Empty Excel templates for setting up a new project: one template per input type (buildings, parcels, neighbourhoods, grid nodes, cables, batteries, charging stations, parking spaces, solar farms, wind farms, electrolysers). A new project repository starts from copies of these templates filled with project-specific data.

### WeatherAndEPEX-data

The working folder in which the generic profiles are produced from public data sources, including the scripts that retrieve and process the raw data:

* **EPEX day-ahead prices**: Dutch day-ahead electricity prices per year (`NL_day_ahead_prices_*.csv` and `Epex*.txt`), with retrieval and processing scripts.
* **Weather data**: KNMI weather data for several stations (De Bilt, Schiphol, Rotterdam) and processing scripts.
* **PVLIB_data**: normalized PV production profiles calculated with [pvlib](https://pvlib-python.readthedocs.io/) from BSRN irradiance measurements at Cabauw, for south-facing panels at 35° tilt and east/west panels at 15° tilt.
* **WindPowerLibData**: normalized wind power production calculated with [windpowerlib](https://windpowerlib.readthedocs.io/) from ERA5 reanalysis wind speeds for several locations (e.g. Geldermalsen, Hoek van Holland).
* **CO2_emission_data**: hourly and quarter-hourly CO₂ emission factors of Dutch electricity, retrieved from the [NED dataportaal](https://ned.nl/).
* **DHW**: the DHWcalc tool and the generated domestic hot water tapping profiles, described in detail on the [Domestic hot water tapping profiles](Domestic hot water tapping profiles.md) page.

### Sources

Documentation of the non-profile figures used in the models, with references to their origins:

* `CAPEX_OPEX_LifeTime`: investment costs, operational costs and lifetimes of energy assets.
* `CO2Emissions`: CO₂ emission factors of energy carriers.
* `EnergyCarrierPrices`: prices of energy carriers.

### Obsolete

Superseded versions of input files, kept for reference.

## Conventions

* Profiles are either normalized (dimensionless, to be scaled by the loader with project-specific capacities or annual demands) or in absolute units per time step (e.g. kWh per quarter-hour for the DHW profiles).
* The time resolution of the model input is 15 minutes, matching the default simulation timestep; source data with a coarser resolution (e.g. hourly prices, 6-hourly soil temperatures) is interpolated or repeated to quarter-hourly values.
* Raw source data, the processing scripts and the resulting input files are kept together, so regenerating an input file after a data update is always possible.
