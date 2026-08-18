# Regional Data — Drechtsteden

This page describes the project-specific input files for the Drechtsteden model. These files are stored in two folders alongside the model:

```
Zenmo-ZERO-Drechtsteden/
├── data_Drechtsteden/   ← region-specific files
└── data_Generic/        ← files shared across LUX projects
```

The national pipeline data (buurten CSV) provides the statistical baseline for all Dutch neighbourhoods. The files on this page add the region-specific layer on top: which buurten are active, how they connect to the electricity grid, what the local warmtevisie says, and what trip patterns drive mobility demand.

---

## Neighbourhood statistics — buurten CSV

| File | `processed/buurten/kerncijfers_buurten_met_geometrie_{year}.csv` |
|---|---|
| Source | WarmteAtlas pipeline (see [Data Pipeline](pipeline.md)) |
| Filtered copy | `data_Drechtsteden/kerncijfers_buurten_{year}.xlsx` (Drechtsteden municipalities only, no WKT) |

The full national buurten CSV is loaded by `NeighborhoodImporter` and filtered to the seven Drechtsteden municipalities (Alblasserdam, Dordrecht, Hardinxveld-Giessendam, Hendrik-Ido-Ambacht, Papendrecht, Sliedrecht, Zwijndrecht) by passing their gemeente codes to the loader. The Excel copy is generated automatically as part of Phase 6 and is provided for inspection and manual reference only — the model reads the CSV directly.

---

## Neighbourhood model configuration

### `Neighborhoods_hasSubModel.xlsx`

Specifies which buurten in Drechtsteden have a detailed sub-model (i.e. a `GridNodes` representation with individual connections). Buurten not listed here are represented as aggregated loads only.

| Column | Description |
|---|---|
| `buurtcode` | CBS buurt code (`BU…`) |
| `hasSubModel` | Boolean — whether a sub-model exists for this buurt |

### `Neighborhoods_to_GridNodes.xlsx`

Maps each active buurt to its parent grid node. This defines which `GridNode` carries the aggregated load and generation of each neighbourhood in the model.

| Column | Description |
|---|---|
| `buurtcode` | CBS buurt code |
| `gridNodeId` | ID of the corresponding `GridNode` in the model |

### `Neighborhoods_heatVision_2025.xlsx`

Contains the local warmtevisie (heat vision) assignments per buurt as planned for 2025. This overrides or supplements the national WarmteTransitie and TVW data from the pipeline with the more detailed Drechtsteden-specific plan.

| Column | Description |
|---|---|
| `buurtcode` | CBS buurt code |
| `warmtevisie` | Assigned heat transition category (e.g. all-electric, district heating, hybrid) |

---

## Electricity grid

### `GridNodes_Drechtsteden.xlsx`

Defines the medium-voltage grid nodes (substations) in the Drechtsteden model. Each node represents a transformer station or connection point in the regional electricity network.

| Column | Description |
|---|---|
| `id` | Unique grid node identifier |
| `name` | Station or location name |
| `capacity_kW` | Net capacity in kW |
| `lat`, `lon` | WGS84 coordinates |

---

## Wind turbines

### `Wind_turbines.xlsx`

Project-specific wind turbine inventory for Drechtsteden. This is a curated subset of the national RIVM data (see [Pipeline Phase 4](pipeline.md#phase-4-wind-turbines)), potentially including planned turbines not yet in the RIVM registry or corrected attributes.

| Column | Description |
|---|---|
| `name` | Turbine name / park |
| `capacity_kW` | Installed capacity (kW) |
| `lat`, `lon` | WGS84 coordinates |
| `buurtcode` | CBS buurt where the turbine is located |

### `data_Generic/windturbines_nl_2026.xlsx`

A national snapshot of all wind turbines as of 2026, used when the region-specific file is not sufficient. Derived from RIVM data processed by the pipeline.

---

## Municipalities

### `data_Generic/municipalities.xlsx`

A lookup table of Dutch municipalities with their CBS gemeente codes, names, and province. Used by loaders that need to resolve a gemeente name to a code or vice versa.

| Column | Description |
|---|---|
| `gm_code` | CBS municipality code (`GM…`) |
| `gm_naam` | Municipality name |
| `prov_naam` | Province name |

---

## Mobility demand

### `AlbatrossProcessedVehicleTrips.csv`

Vehicle trip patterns for the Drechtsteden region derived from the [Albatross](https://albatross.uvt.nl/) activity-based travel demand model. The model uses these patterns to generate time-varying EV charging demand profiles per neighbourhood.

Each row represents an aggregated trip chain. Key fields include departure time, duration, destination type, and vehicle type. The model draws from this file at simulation start to initialise the trip schedule of each modelled vehicle.

### `inputTruckTripPatterns.csv`

Freight trip patterns for trucks. Contains hourly trip probability distributions used to schedule truck departures and arrivals at logistics locations in the model.

### `inputECookerPatterns.csv`

Usage patterns for electric cooking appliances (induction hobs, electric ovens). Provides time-of-day demand profiles that feed into the residential electricity demand model when cooking electrification scenarios are simulated.

---

## Data update cadence

| Dataset | Update trigger |
|---|---|
| Buurten CSV (national pipeline) | Re-run `python run_pipeline.py` — CBS and ElaadNL data typically updated annually |
| CBS Verwarmingsinstallaties Excel | Replace `Hoofdverwarmingsinstallaties_woningen_2022_2024.xlsx` when CBS publishes a new edition; re-run `--verwarming --buurten` |
| WarmteTransitie / TVW | Re-run `--warmtetransitie --tvw --buurten` — RVO/WarmteAtlas updates continuously as municipalities publish plans |
| ElaadNL EV prognoses | Re-run `--elaadnl --buurten` — ElaadNL updates scenarios annually |
| GridNodes / Neighborhoods Excel files | Updated manually when the physical grid configuration or model scope changes |
| Wind turbines | Update `Wind_turbines.xlsx` manually; or re-run pipeline `--windturbines` to refresh from RIVM |
