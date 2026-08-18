# Data

This section covers the data pipeline and regional input files from a developer perspective. For a non-technical explanation of what each source provides and what assumptions are made, see the [user guide data section](../../user/data/sources.md).

## Architecture

Data enters the model through two paths:

```
Public sources (WFS / REST API / Excel / OData)
        │
        ▼
data/warmteatlas/run_pipeline.py   (Python — 6 phases)
        │
        ▼
processed/buurten/kerncijfers_buurten_met_geometrie_{year}.csv
        │
        ├── NeighborhoodImporter.java  →  LinkedHashMap<String, J_Neighborhood>
        │
        └── region-specific Excel / CSV files
             (GridNodes, heatVision, vehicle trips, …)
                │
                ▼
            AnyLogic model
```

**Path 1 — Pipeline:** A Python pipeline downloads raw geodata from public WFS and REST endpoints, processes and spatially joins it, and assembles everything into a single semicolon-separated CSV per CBS year (one row per buurt, covering all ~17,000 Dutch buurten). `NeighborhoodImporter.java` reads this CSV and populates `J_Neighborhood` objects.

**Path 2 — Regional files:** Project-specific Excel and CSV files in `Zenmo-ZERO-Drechtsteden/data_Drechtsteden/` and `data_Generic/` are loaded directly by dedicated importers. These define model scope (active neighbourhoods), grid topology, local warmtevisie assignments, and mobility demand patterns.

## Pipeline entry point

```bash
cd data/warmteatlas
pip install -r requirements.txt

python run_pipeline.py                    # full pipeline
python run_pipeline.py --download         # Phase 1 only
python run_pipeline.py --process          # Phase 2 only
python run_pipeline.py --verwarming       # Phase 3 only
python run_pipeline.py --windturbines     # Phase 4 only
python run_pipeline.py --elaadnl          # Phase 5 only  (~18 h first run)
python run_pipeline.py --tvw              # Phase 5b only
python run_pipeline.py --warmtetransitie  # Phase 5c only
python run_pipeline.py --solar            # Phase 5d only
python run_pipeline.py --buurten          # Phase 6 only
```

All phases are independently resumable. Downloads are cached as GeoPackage files in `raw/`; processed outputs are cached as CSV. Re-running a completed phase is a no-op unless `--force` is passed.

## Key files

| File | Description |
|---|---|
| `run_pipeline.py` | Orchestrator — runs phases in order, handles errors and logging |
| `config.py` | WFS endpoints, CBS years, cache settings, active WarmteAtlas layer list |
| `download_sources.py` | Phase 1 — WFS downloads with pagination and adaptive BBOX tiling |
| `process_features.py` | Phase 2 — spatial join of WarmteAtlas features to CBS boundaries |
| `make_verwarmingsinstallaties_csv.py` | Phase 3 — parse CBS heating-type Excel |
| `make_windturbines_csv.py` | Phase 4 — RIVM wind turbine WFS |
| `make_elaadnl_csv.py` | Phase 5 — ElaadNL REST API with per-request JSON cache |
| `make_tvw_csv.py` | Phase 5b — TVW polygon → buurt spatial match |
| `make_warmtetransitie_csv.py` | Phase 5c — RVO ArcGIS FeatureServer |
| `make_solar_csv.py` | Phase 5d — CBS OData solar statistics |
| `make_buurten_csv.py` | Phase 6 — merge all sources, fill missing values, write final CSV |
| `NeighborhoodImporter.java` | Java loader — reads buurten CSV into `J_Neighborhood` objects |
| `J_Neighborhood.java` | Data class with builder, getters and setters |
