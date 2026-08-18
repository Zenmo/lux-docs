# Data Pipeline

The pipeline lives in `data/warmteatlas/` and is orchestrated by `run_pipeline.py`. It runs in six sequential phases. Each phase is independent and can be re-run without re-running earlier ones.

The final output — used directly by the model — is:

```
processed/buurten/kerncijfers_buurten_met_geometrie_{year}.csv
```

One file is produced per CBS year (currently 2023, 2024, 2025). Each row is one buurt. Columns come from all phases below merged on `codering` (the CBS buurt code, e.g. `BU00340000`).

---

## Phase 1 — Download raw geodata

**Script:** `download_sources.py`

Downloads three families of spatial datasets and caches them as GeoPackage files in `raw/`. Re-runs skip files that are already present and younger than 30 days.

### WarmteAtlas layers

| Property | Value |
|---|---|
| Source | RVO / WarmteAtlas GeoServer |
| Endpoint | `https://www.warmteatlas.nl/geoserver/WarmteAtlas/wfs` |
| Format | WFS 2.0.0 → GeoJSON → GeoPackage |
| CRS | EPSG:28992 (RD New) |
| Cache path | `raw/warmteatlas/<LayerName>/<date>.gpkg` |

The currently active layers cover heat demand, heat networks, geothermal potential, aquathermy, WKO (thermal energy storage), biogas, biomass, renewable energy subsidies (SDE+), major combustion installations, gas use per business area, and TVW (Transitievisie Warmte) progress. A `WARMTEATLAS_LAYERS_FULL` list in `config.py` documents all 84 available layers; several large or outdated ones are excluded from the active download.

Pagination: the WFS server caps responses at 1000 features regardless of the `COUNT` parameter and does not support `STARTINDEX` on all layers. The downloader uses two strategies: standard `STARTINDEX` pagination for layers that support it, and adaptive BBOX tiling (starting at a 5×7 national grid, recursively splitting any tile that hits the 900-feature threshold) for layers that do not.

### CBS Wijk- en Buurtkaart

| Property | Value |
|---|---|
| Source | CBS via PDOK |
| Endpoint | `https://service.pdok.nl/cbs/wijkenbuurten/{year}/wfs/v1_0` |
| Years | 2023, 2024, 2025 |
| Layers | `buurten` (~17,000 features), `gemeenten` (~342 features) |
| Cache path | `raw/cbs_wijkenbuurten/{year}/{layer}.gpkg` |

`buurten` uses BBOX tiling because the PDOK CBS WFS ignores `STARTINDEX` for this layer. `gemeenten` uses standard pagination.

### CBS Postcode boundaries

| Property | Value |
|---|---|
| Source | CBS via PDOK |
| Endpoints | `…/cbs/postcode4/{year}/wfs/v1_0`, `…/cbs/postcode6/{year}/wfs/v1_0` |
| Years | 2023, 2024, 2025 (2025 falls back to 2024 until CBS publishes it) |
| Cache path | `raw/cbs_pc4/{year}/pc4.gpkg`, `raw/cbs_pc6/{year}/pc6.gpkg` |

Both PC4 and PC6 use BBOX tiling for the same reason as buurten.

---

## Phase 2 — Match WarmteAtlas features to CBS boundaries

**Script:** `process_features.py`

For each active WarmteAtlas layer, every feature is spatially matched to the CBS buurten, gemeenten, PC4 and PC6 boundaries for all three years. The match strategy depends on geometry type:

- **Point features** — matched by point-in-polygon to the boundary that contains the point.
- **Line features** — the centroid of the line (computed in EPSG:28992) is used as a representative point.
- **Polygon features** — matched to the boundary with the largest intersection area (tie broken alphabetically on code).

The result is one CSV per layer with all original WarmteAtlas attributes plus match columns for all three CBS years:

| Column pattern | Example |
|---|---|
| `buurtcode_{year}` | `BU00340000` |
| `gemeentecode_{year}` | `GM0034` |
| `pc4_code_{year}` | `3011` |
| `pc6_code_{year}` | `3011AA` |
| `buurtcode_gewijzigd` | `True` when code differs between years (municipal boundary reform) |

Unmatched features (e.g. features that fall outside any CBS boundary, such as offshore infrastructure) are written to a separate `*_onbekend_match_*.csv` file rather than silently dropped.

Output: `processed/<LayerName>_nl_<date>.csv`

---

## Phase 3 — Heating type fractions

**Script:** `make_verwarmingsinstallaties_csv.py`  
**Source:** CBS *Hoofdverwarmingsinstallaties woningen* — local Excel file (`Hoofdverwarmingsinstallaties_woningen_2022_2024.xlsx`)

CBS publishes the share of dwellings in each heating category at buurt, wijk and gemeente level. The pipeline parses the Excel and produces one CSV per year.

Heating categories (expressed as percentages in the source, converted to fractions in the loader):

| CSV column | Description |
|---|---|
| `individuele_cv` | Individual gas boiler |
| `blokverwarming` | Collective / block heating (gas) |
| `stadsverwarming_hoog_gas` | District heating with high gas share |
| `stadsverwarming_laag_gas` | District heating with low gas share |
| `stadsverwarming_zonder_gas` | Fully renewable district heating |
| `elektrisch_hoog_gas` | Heat pump with significant gas backup (hybrid) |
| `elektrisch_laag_gas` | Heat pump, minimal or no gas (fully electric) |

Where a buurt has no data, the pipeline falls back to the parent wijk, then the gemeente. The loader combines `individuele_cv + blokverwarming` → `fractionHouseholdsNaturalGasBurner` and maps the remaining categories to their respective fraction fields in `J_Neighborhood`.

Output: `processed/verwarmingsinstallaties_buurten_<date>.csv`

---

## Phase 4 — Wind turbines

**Script:** `make_windturbines_csv.py`  
**Source:** RIVM, *Windturbines in Nederland* WFS (`https://data.rivm.nl/geo/alo/wfs`)

RIVM publishes annual snapshots of all registered wind turbines in the Netherlands as a WFS point layer. The pipeline downloads the snapshot for each CBS year and spatially joins each turbine to its buurt and gemeente.

| Property | Value |
|---|---|
| RIVM layer 2023 | `alo:rivm_20230101_Windturbines_2022_ashoogte` |
| RIVM layer 2024 | `alo:rivm_20240101_Windturbines_ashoogte` |
| RIVM layer 2025 | `alo:rivm_20250101_windturbines_ashoogte` |
| Key attributes | Hub height (m), rotor diameter (m), installed capacity (kW) |

Output: `processed/windturbines_{year}_<date>.csv`

---

## Phase 5 — ElaadNL EV prognoses

**Script:** `make_elaadnl_csv.py`  
**Source:** ElaadNL Outlook Scenariotool API (`https://api-outlook-v2-prd.thankfulrock-fcd5ae60.westeurope.azurecontainerapps.io`)  
**License:** CC BY-NC-ND 4.0 — internal non-commercial use only.

ElaadNL publishes EV prognoses per Dutch buurt for four scenarios (low, middle, high, realization) and four vehicle modalities (car BEV, car PHEV, van, truck), covering years 2025–2050. Each combination is one API call; the full matrix is approximately 700,000 requests (~17,000 buurten × 4 scenarios × 4 modalities).

**Caching:** Each API response is saved to `raw/elaadnl/{scenario}/{modality}/{buurtcode}.json` immediately after download. Re-runs and interrupted runs skip combinations that already have a cached file. The first full run takes approximately 18 hours; subsequent runs complete in seconds.

The pipeline pivots the long-format data to wide format for the buurten CSV. Only four years are kept to limit column count: 2025, 2030, 2040, 2050.

| CSV column pattern | Example |
|---|---|
| `ev_car_bev_{scenario}_{year}` | `ev_car_bev_middle_2030` |
| `ev_car_phev_{scenario}_{year}` | `ev_car_phev_high_2050` |
| `ev_van_{scenario}_{year}` | `ev_van_low_2025` |
| `ev_truck_{scenario}_{year}` | `ev_truck_middle_2040` |

Note: CBS does not publish van or truck totals at buurt level, so `nbOfBenzineDieselVans` and `nbOfBenzineDieselTrucks` in the model are always 0. Only the ElaadNL electric counts are available for those categories.

Output: `processed/elaadnl_ev_prognoses_<date>.csv`

---

## Phase 5b — TVW (Transitievisie Warmte) progress

**Script:** `make_tvw_csv.py`  
**Source:** WarmteAtlas, layer `TVW_voortgang` (already downloaded in Phase 1)

TVW_voortgang is a polygon layer published by municipalities containing the status of their Transitie Visie Warmte (TVW) — the legally required neighbourhood heat transition plan. The pipeline matches each buurt to the TVW polygon with the largest intersection area.

| CSV column | Description |
|---|---|
| `tvw_gemeentenaam` | Municipality name |
| `tvw_stand_tvw` | Progress status of the TVW process |
| `tvw_status` | Publication status |
| `tvw_online_url` | Link to the published TVW document |

Buurten in municipalities without a published TVW get `n.a.` for all columns.

Output: `processed/tvw_voortgang_buurten_<date>.csv`

---

## Phase 5c — WarmteTransitie plans

**Script:** `make_warmtetransitie_csv.py`  
**Source:** RVO / WarmteAtlas, WARMTETRANSITIE_publiek ArcGIS FeatureServer  
URL: `https://services.arcgis.com/kE0BiyvJHb5SwQv7/arcgis/rest/services/WARMTETRANSITIE_publiek/FeatureServer/0`

WarmteTransitie polygons represent heat transition plan areas published by municipalities. Unlike TVW, these contain detailed plan data including planned heating solutions, number of dwellings affected, isolation targets, and energy carriers. Each buurt is matched to the polygon with the largest overlap.

As of mid-2026, approximately 211 municipalities have published a plan, covering roughly 750 buurten. All columns are prefixed `wtp_` in the buurten CSV to avoid clashes with CBS column names.

Output: `processed/warmtetransitie_buurten_<date>.csv`

---

## Phase 5d — CBS Zonnestroom (solar capacity)

**Script:** `make_solar_csv.py`  
**Source:** CBS OData API — dataset series *Zonnestroom; wijken en buurten*

| CBS dataset | Year |
|---|---|
| `86044NED` | 2022 (most recent as of 2026) |
| `85775NED` | 2021 |
| `85447NED` | 2020 |

CBS publishes the number of residential solar installations and their total installed capacity in kWp at buurt level. The pipeline uses OData pagination (`$skip`) to retrieve all records and outputs two columns per buurt:

| CSV column | Description |
|---|---|
| `solar_woningen_kwp` | Total installed solar capacity at homes (kWp) |
| `solar_woningen_count` | Number of solar installations at homes |

The buurten assembly phase (Phase 6) picks the nearest available CBS solar year for each boundary year. The loader maps `solar_woningen_kwp` directly to `J_Neighborhood.installedSolarCapacity`.

Output: `processed/solar_buurten_<date>.csv`

---

## Phase 6 — Assemble enriched buurten CSV

**Script:** `make_buurten_csv.py`

Merges all phase outputs into the final per-buurt CSV. For each CBS year:

1. Load CBS kerncijfers (households, housing stock, energy use, vehicles, company sectors) from CBS OData via the `kerncijfers_buurten.py` helper.
2. Load WKT geometry and centroids from the CBS buurten GeoPackage (Phase 1). Centroids are computed in EPSG:28992 then projected to WGS84 — never in geographic coordinates.
3. Left-join verwarmingsinstallaties fractions (Phase 3), using the nearest available year when an exact match is not present.
4. Left-join ElaadNL EV columns in wide format (Phase 5).
5. Left-join WarmteTransitie plan data (Phase 5c), matched on buurt.
6. Left-join TVW progress status (Phase 5b).
7. Left-join CBS solar capacity (Phase 5d), using the nearest available CBS solar year.
8. Fill missing values: share/average columns fall back to the CBS gemeente value; stadsverwarming falls back to gemeente then 0; business sub-categories are estimated from buurt total × gemeente fraction; EV and solar columns get −99999 when absent.
9. Write to `processed/buurten/kerncijfers_buurten_met_geometrie_{year}.csv`.
10. Write a filtered Excel for Drechtsteden municipalities (no WKT column) to `processed/buurten/kerncijfers_buurten_drechtsteden_{year}.xlsx`.

### Key output columns

| Group | Columns |
|---|---|
| Identity | `wijken_en_buurten`, `codering`, `gemeentenaam` |
| Geometry | `wkt_geometry`, `latitude`, `longitude` |
| Area | `oppervlakte_land`, `oppervlakte_water` (hectares) |
| Housing | `huishoudens_totaal`, `aardgasvrije_woningen`, `aardgaswoningen`, `woningen_met_zonnestroom`, `woningen_hoofdzakelijk_elektrisch_verwarmd`, `aantal_publieke_laadpalen` |
| Energy use | `gemiddelde_elektriciteitslevering`, `gemiddelde_elektriciteitsteruglevering`, `gemiddeld_aardgasverbruik` |
| Company sectors | `a_landbouw_…`, `bf_nijverheid_…`, `gi_handel_…`, `hj_vervoer_…`, `kl_financiele_…`, `mn_zakelijke_…`, `oq_overheid_…`, `ru_cultuur_…` |
| Vehicles | `personenautos_totaal` |
| Heating fractions | `individuele_cv`, `blokverwarming`, `stadsverwarming_*`, `elektrisch_hoog_gas`, `elektrisch_laag_gas` (all %) |
| EV prognoses | `ev_car_bev_{scenario}_{year}`, `ev_car_phev_…`, `ev_van_…`, `ev_truck_…` |
| Solar | `solar_woningen_kwp`, `solar_woningen_count` |
| TVW | `tvw_stand_tvw`, `tvw_status`, `tvw_online_url` |
| WarmteTransitie | `wtp_*` (50+ columns, prefixed to avoid collision) |

Missing value sentinel: `n.a.` (string in CSV); −99999 for numeric columns with no available data.

---

## Reading the data into the model

`NeighborhoodImporter.java` reads the buurten CSV and populates a `LinkedHashMap<String, J_Neighborhood>` keyed by buurt code.

```java
LinkedHashMap<String, J_Neighborhood> buurten = NeighborhoodImporter.load(
    "/path/to/processed/buurten/kerncijfers_buurten_met_geometrie_2024.csv",
    new String[]{"GM0505", "GM0506"},  // null to load all NL municipalities
    "middle",   // ElaadNL scenario: low / middle / high / realization
    2030        // EV prognosis year: 2025 / 2030 / 2040 / 2050
);
```

The loader filters by municipality code, applies the selected EV scenario and year, and computes derived fields (e.g. `nbOfBenzineDieselCars = total - BEV - PHEV`).
