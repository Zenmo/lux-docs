# Energy Model

The `EnergyModel` is the top-level simulation agent of the [engine](overview.md). It orchestrates the entire simulation by managing all other agent populations — [GridConnections](grid_connections.md), [GridNodes](grid_nodes.md), and [EnergyCoops](energy_coops.md) — and stepping through time.

The EnergyModel is also where all energy flows of all agents in the model accumulate at each timestep.

The following key collections are held by the EnergyModel:

* **`c_gridConnections`**: All [GridConnections](grid_connections.md) in the simulation.
* **`c_gridNodesTopLevel` / `c_gridNodesNotTopLevel` / `c_gridNodesHeat`**: The [GridNode](grid_nodes.md) collections organized by hierarchy and energy carrier.
* **`c_energyAssets` / `c_productionAssets` / `c_storageAssets` / `c_ambientDependentAssets`**: Asset collections for iteration and management.

The EnergyModel holds time parameters (`J_TimeParameters`) and time variables (`J_TimeVariables`) as well as profile pointers, like those for weather and pricing data:

* **`pp_ambientTemperature_degC`**: Ambient temperature profile.
* **`pp_windProduction_fr`**: Wind production factor profile.
* **`pp_dayAheadElectricityPricing_eurpMWh`**: Day-ahead electricity price profile.

The engine runs two types of simulations: **Live Simulation** (interactive feedback) and **RapidRun Simulation** (batch comparison of scenarios).