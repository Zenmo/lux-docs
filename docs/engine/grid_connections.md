# GridConnections

GridConnections are agents that represent a connection to the grid. These are usually homes or companies, but could also be solar fields, windmills, charging stations, large-scale batteries, or district heating heat sources.

**Parameters:**

* **`p_gridConnectionID`**: A unique string to identify the GridConnection.
* **`p_address`**: A class containing address details (postal code, street name, house number, etc.).
* **`p_energyManagement`**: The [EMS](energy_management_systems.md) (`I_EnergyManagement`) controlling the flexible assets.
* **`p_parentNodeElectricID` / `p_parentNodeHeatID`**: The IDs of the parent [GridNodes](grid_nodes.md) for electricity and heat.

**Metadata:**

* **`v_liveConnectionMetaData`**: Contains the contracted delivery/feed-in capacity, the physical capacity, and whether this information is known or estimated.
* **`v_liveAssetsMetaData`**: Metadata about the assets (active flow categories, installed capacities).


**Key methods:**

* **`f_updateFlexAssetFlows()`**: Called by the EMS to operate the flexible energy assets.
* **`f_connectToJ_EA(J_EAFixed)` / `f_removeTheJ_EAFixed(J_EAFixed)`**: Add and remove energy assets.
* **`f_calculateEnergyBalance()`**: Part of the main simulation loop. Called by the EnergyModel at every timestep. Resets all per-timestep values, then manages and operates all assets.
* **`f_connectionMetering()`**: Called at the end of `f_calculateEnergyBalance`. Checks for heat imbalances (which would stop the simulation), then stores the timestep data in the live or rapid-run data classes.

