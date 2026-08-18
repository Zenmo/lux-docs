# Data Sources & Assumptions

The LUX model is built on a combination of national public datasets and region-specific input files. This page explains what each data source contributes to the model, how current the data is, and what assumptions have been made where data is incomplete or unavailable.

All data is open and publicly available unless noted otherwise.

---

## CBS — Neighbourhood statistics

**What it is:** Statistics Netherlands (CBS) publishes annual neighbourhood-level statistics for all Dutch *buurten* — roughly 17,000 sub-municipality areas across the Netherlands. These form the statistical backbone of every neighbourhood in the model.

**What it provides:**

| Topic | What the model uses |
|---|---|
| Population & households | Number of households per neighbourhood |
| Housing stock | Totals for gas-free homes, gas-connected homes, homes with solar panels, homes with electric heating |
| Energy use | Average electricity consumption, electricity fed back to the grid (solar export), average gas consumption per address |
| Company locations | Number of business establishments per economic sector (agriculture, industry, trade, transport, services, government & care, culture) |
| Vehicles | Total number of registered personal cars |
| Public charging | Number of public EV charging stations |
| Surface area | Land area and water area in hectares |

**Coverage:** All Dutch neighbourhoods for reference years 2023, 2024, and 2025.

**Assumptions & limitations:**

- CBS does not publish van or truck totals at neighbourhood level. The number of combustion-engine vans and trucks in a neighbourhood is therefore unknown; only the ElaadNL electric vehicle prognosis counts (see below) are available for those categories.
- When CBS does not report a value for an individual neighbourhood (this happens for small neighbourhoods or where privacy thresholds apply), the model substitutes the value from the parent municipality. This is indicated in the model data with a flag (`data_from_mun_average = True`). Where even the municipality value is unavailable, a sentinel value of −99999 is used.
- Electricity and gas consumption figures are averages per *address*, not per household. They include non-residential addresses in the neighbourhood.

**Source:** CBS Wijk- en Buurtkaart, CBS OData (StatLine)

---

## CBS — Heating type distribution

**What it is:** CBS publishes how households heat their homes, broken down by installation type, for each neighbourhood, district and municipality. The categories are:

| Heating type | Description |
|---|---|
| Individual gas boiler (*individuele CV*) | Most common type; a gas-fired central heating boiler serving one home |
| Block / collective heating (*blokverwarming*) | A shared gas-fired installation serving a building or complex |
| District heating — high gas (*stadsverwarming, hoog gas*) | Connected to a heat network but the network relies heavily on gas as a backup |
| District heating — low gas (*stadsverwarming, laag gas*) | Heat network with limited gas involvement |
| District heating — no gas (*stadsverwarming, zonder gas*) | Fully renewable heat network |
| Hybrid heat pump (*elektrisch, hoog gas*) | A heat pump combined with a gas boiler as backup |
| Fully electric (*elektrisch, laag gas*) | Heat pump with minimal or no gas use |

The model uses these percentages as fractions of all households to allocate heating demand across technologies.

**Assumptions & limitations:**

- The data is reported as percentages. Where a neighbourhood percentage is missing, the model uses the district (*wijk*) percentage, falling back to the municipality percentage if that is also unavailable.
- The categories *elektrisch, laag gas* and *elektrisch, zonder gas* (fully electric, no gas at all) are not reported separately at neighbourhood level by CBS — they are combined into a single "mainly electric" category. The model therefore cannot distinguish between households that still use gas for cooking from those that use no gas at all.
- Data is available for reference years 2022, 2023, and 2024.

**Source:** CBS Hoofdverwarmingsinstallaties woningen

---

## ElaadNL — Electric vehicle prognoses

**What it is:** ElaadNL, the Dutch EV infrastructure knowledge centre, publishes annual prognoses for the number of electric vehicles at neighbourhood level across the Netherlands. These prognoses cover four vehicle categories and four scenarios.

**Vehicle categories:**

- Passenger cars — battery electric (BEV)
- Passenger cars — plug-in hybrid (PHEV)
- Vans — electric
- Trucks — electric

**Scenarios:**

| Scenario | Description |
|---|---|
| Low | Conservative growth — slower EV adoption |
| Middle | Central estimate — the most likely trajectory |
| High | Accelerated adoption — ambitious but plausible |
| Realization | Actual registrations to date (available for recent years only) |

**What the model uses:** When loading neighbourhood data, a single scenario and year are selected (e.g. *middle, 2030*). The model uses those counts to split the total CBS car count into electric, hybrid and combustion-engine vehicles. For vans and trucks, where CBS provides no total, only the ElaadNL electric count is used.

**Coverage:** Prognoses for years 2025 to 2050 in five-year steps. All Dutch neighbourhoods.

**Assumptions & limitations:**

- The prognoses are at neighbourhood level but are modelled from municipality and national trends scaled down. They represent expected fleet composition, not registered addresses.
- The *realization* scenario is only available for years already passed. For future years it falls back to the *middle* scenario.
- License: CC BY-NC-ND 4.0. Internal non-commercial use is permitted; redistributing the data or derived outputs externally requires written permission from ElaadNL.

**Source:** ElaadNL Outlook Scenariotool

---

## CBS — Solar capacity

**What it is:** CBS publishes the number of solar installations on homes and their total installed capacity in kWp (kilowatt-peak) per neighbourhood.

**What the model uses:**

- `solar_woningen_kwp` — total installed residential solar capacity in the neighbourhood (kWp)
- `solar_woningen_count` — number of residential solar installations

This feeds into the model as pre-existing installed solar capacity in each neighbourhood.

**Assumptions & limitations:**

- The data covers **residential** solar only (panels on homes). Commercial or utility-scale solar on business premises is not included at neighbourhood level.
- The most recent CBS edition covers reference year 2022. The model uses this for all modelling years until CBS publishes a newer edition.

**Source:** CBS Zonnestroom, wijken en buurten (OData StatLine)

---

## RIVM — Wind turbines

**What it is:** The National Institute for Public Health and the Environment (RIVM) maintains a registry of all wind turbines in the Netherlands, updated annually. The model uses this to determine the location, capacity and hub height of existing wind turbines in and around the region.

**What the model uses:** Each registered turbine is matched to its neighbourhood and municipality. Key attributes: installed capacity (kW), hub height (m), rotor diameter (m).

**Coverage:** Annual snapshots for 2023, 2024 and 2025.

**Assumptions & limitations:**

- Turbines under construction or planned but not yet registered are not included.
- Decommissioned turbines may remain in the registry briefly after removal.

**Source:** RIVM Windturbines in Nederland

---

## WarmteAtlas — Heat transition spatial data

**What it is:** The WarmteAtlas is a national spatial data portal published by RVO (Netherlands Enterprise Agency) that aggregates dozens of datasets relevant to the energy and heat transition. The model draws on a curated subset of these layers.

**What it provides:**

| Theme | Examples |
|---|---|
| Current heat demand | Estimated current heat demand per neighbourhood; projected 2050 demand |
| Heat networks | Existing and planned district heating networks and their development status |
| Geothermal potential | Shallow (LT) and deep (MT) geothermal heat potential |
| Aquathermy | Potential for heat/cold extraction from wastewater treatment, sewage pumping stations, and surface water |
| Underground thermal storage (WKO) | Open and closed groundwater heat/cold storage capacities |
| Renewable energy production | SDE+ subsidised installations (electricity, heat, renewable fuels, CO₂-neutral) |
| Large heat producers | Industrial sites, data centres, condensation heat sources |
| Biogas and biomass | Locations and capacities of biogas and biomass installations |
| Gas use per business area | Average gas intensity per commercial floor area |

**Assumptions & limitations:**

- WarmteAtlas data is updated at irregular intervals by RVO; individual layers may lag behind reality by one to several years.
- Some layers are excluded from the model because they are too large to process practically, contain data from before 2016, or are not relevant to the heat transition analysis. The full list of available layers is documented in the developer guide.
- Features that fall outside any CBS neighbourhood boundary (e.g. offshore installations) are recorded as unmatched and excluded from neighbourhood-level statistics.

**Source:** RVO WarmteAtlas

---

## TVW — Municipal heat transition progress

**What it is:** Every Dutch municipality is legally required to produce a *Transitievisie Warmte* (TVW) — a plan describing which neighbourhoods will transition away from gas, by when, and using which alternative heat source. WarmteAtlas publishes the status of each municipality's TVW process as a spatial layer.

**What the model uses:** Each neighbourhood is matched to its municipality's TVW record, providing:

- The stage the municipality has reached in its TVW process
- A link to the published TVW document (where available)

**Assumptions & limitations:**

- As of mid-2026, not all municipalities have published or completed their TVW. Unmatched neighbourhoods show no TVW data.
- TVW plans are indicative, not binding — actual transition timelines frequently change.

**Source:** RVO / WarmteAtlas TVW_voortgang layer

---

## WarmteTransitie — Published neighbourhood heat plans

**What it is:** A more detailed layer than TVW, containing the specific heat transition plans that municipalities have published for individual plan areas (*gebieden*). Where a municipality has published a plan, this includes the planned heating solution, number of dwellings affected, insulation targets, energy carriers, and implementation timeline.

**What the model uses:** Each neighbourhood is matched to the plan area that overlaps it most. If a neighbourhood straddles two plan areas, the plan for the larger overlap is used.

**Coverage:** Approximately 211 municipalities had published plans as of mid-2026, covering around 750 of the ~17,000 Dutch neighbourhoods. The dataset grows as more municipalities publish.

**Assumptions & limitations:**

- Most neighbourhoods are currently unmatched (no published plan yet). This is not a data gap but reflects the current state of the planning process.
- Plan areas do not align with CBS neighbourhood boundaries. The largest-overlap matching may assign a neighbourhood to a plan that covers only part of it.

**Source:** RVO WARMTETRANSITIE_publiek (ArcGIS FeatureServer)

---

## Missing values and fill strategy

Where data for an individual neighbourhood is missing, the model applies a consistent fill strategy rather than using zero (which would misrepresent the situation):

1. **Share and average columns** (e.g. percentage of gas-free homes, average electricity use) are filled with the value from the parent municipality.
2. **District heating columns** are filled from the municipality and then set to zero if still missing — because absence of district heating data genuinely means the neighbourhood has no district heating.
3. **Business sector sub-categories** are estimated as: neighbourhood total businesses × municipality sector share.
4. **EV and solar columns** use −99999 as a sentinel when the data source has not yet been run or has not returned a value. The model treats −99999 as "data not available" rather than zero.

A flag column `data_from_mun_average` marks every neighbourhood that received at least one column filled from municipality-level data.
