# Regional Data — Drechtsteden

In addition to the national datasets that apply to all Dutch neighbourhoods, the Drechtsteden model uses a set of region-specific input files. These cover the local electricity grid, the Drechtsteden warmtevisie, vehicle travel behaviour, and the model scope (which neighbourhoods are included).

---

## Model scope — which neighbourhoods are active

The model covers all neighbourhoods in the seven Drechtsteden municipalities:

- Alblasserdam
- Dordrecht
- Hardinxveld-Giessendam
- Hendrik-Ido-Ambacht
- Papendrecht
- Sliedrecht
- Zwijndrecht

Not all neighbourhoods are modelled at the same level of detail. Some have a full sub-model with individual connections to the electricity grid; others are represented as aggregated loads only. This distinction is recorded in `Neighborhoods_hasSubModel.xlsx`.

---

## Warmtevisie Drechtsteden 2025

**What it is:** The seven Drechtsteden municipalities have produced a joint *warmtevisie* — their collective plan for the heat transition up to 2025 and beyond. This goes beyond the national TVW data in specificity: it assigns a planned heating solution to each individual neighbourhood in the region.

**What the model uses:** Each neighbourhood in Drechtsteden is tagged with its warmtevisie category from `Neighborhoods_heatVision_2025.xlsx`. This assignment drives which heating technologies are simulated in that neighbourhood under the heat transition scenarios.

**Assumptions:** The warmtevisie represents the municipalities' ambitions and planning intentions as of 2025. Actual transition timelines and technology choices may differ. Where a neighbourhood does not yet have an assignment, the national WarmteTransitie data (from RVO) is used as a fallback.

---

## Electricity grid

**What it is:** The model represents the regional medium-voltage electricity grid as a network of *grid nodes* (substations and connection points) and the connections between them.

**What it provides:** Each grid node has a location, a name, and a net capacity in kW. Neighbourhoods are mapped to their parent grid node, so that the electricity demand and supply of each neighbourhood flows through the correct part of the network.

**Source:** `GridNodes_Drechtsteden.xlsx` — compiled from publicly available network topology data and verified against operator information.

**Assumptions & limitations:**

- The grid is modelled as a *copper plate* within each substation zone: congestion can only occur at the substation (transformer) level, not in individual cables. This is a deliberate simplification — LUX does not simulate current flows or cable-level constraints.
- Grid capacities reflect the current situation. Future grid reinforcements planned by the network operator are not automatically included.

---

## Wind turbines

**What it is:** A curated inventory of wind turbines in and directly around the Drechtsteden region.

**Source:** Based on the national RIVM wind turbine registry (see [Data Sources](sources.md#rivm-wind-turbines)), supplemented where needed with local corrections or planned turbines not yet in the national registry.

**What the model uses:** Each turbine contributes its installed capacity to its neighbourhood's renewable generation.

---

## Vehicle travel behaviour

The model simulates the charging demand of electric vehicles based on observed travel behaviour in the Drechtsteden region.

### Personal car trips — Albatross

**What it is:** The [Albatross](https://albatross.uvt.nl/) model is a Dutch activity-based travel demand model that generates synthetic travel schedules for individuals based on their household characteristics and daily activity patterns. The processed output used here contains vehicle trip chains for the Drechtsteden region.

**What the model uses:** Trip departure times, durations, and destination types are used to determine when EVs are parked, how far they have driven, and when and where they will charge. This produces a realistic, time-varying EV charging load profile rather than a flat average.

**Assumptions:** The Albatross data represents a typical weekday. Weekend and seasonal variation is accounted for through scaling factors. The travel data reflects behaviour patterns from the base year and does not automatically update as travel patterns change.

### Freight — truck trip patterns

**What it is:** Hourly probability distributions for freight truck trips in the region.

**What the model uses:** These distributions determine when trucks depart and arrive at logistics locations in the model, driving time-varying demand for electric truck charging.

### Cooking electrification — electric cooker patterns

**What it is:** Time-of-day demand profiles for electric cooking appliances (induction hobs, electric ovens).

**What the model uses:** When scenarios include cooking electrification (switching from gas to electric cooking), these profiles are used to estimate the additional electricity demand and its timing throughout the day.

---

## Data freshness

The table below summarises how current each regional dataset is and when it should be refreshed.

| Dataset | Reference period | When to update |
|---|---|---|
| Buurten CBS statistics | 2024 (latest published) | When CBS publishes 2025 data |
| Heating type fractions | 2022–2024 | When CBS publishes a new edition |
| ElaadNL EV prognoses | Published 2025; prognosis to 2050 | Annually when ElaadNL releases updated scenarios |
| CBS solar capacity | 2022 (latest at buurt level) | When CBS publishes newer buurt-level data |
| RIVM wind turbines | 2025 snapshot | Annually |
| WarmteTransitie / TVW | Ongoing (as municipalities publish) | Re-run quarterly to pick up newly published plans |
| Warmtevisie Drechtsteden | 2025 | When the municipalities update their plan |
| Grid nodes | Current network | When topology changes |
| Vehicle trip patterns | Albatross base year | When a new Albatross run is available for the region |
