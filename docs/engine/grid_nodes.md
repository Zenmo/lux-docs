# GridNodes

GridNodes are part of either the electricity or heat grid, depending on the value of `p_energyCarrier`. They form a hierarchical tree structure — the model does not support rings in the gridnode topology.

**Parameters:**

* **`p_gridNodeID`**: A unique identifier (e.g. T0, T1, T2).
* **`p_energyCarrier`**: The `OL_EnergyCarriers` type for this node (electricity or heat).
* **`p_capacity_kW`**: The symmetrical capacity of this grid node.
* **`p_realCapacityAvailable`**: Whether the capacity is known or estimated.
* **`p_parentNodeID`**: The ID of the parent node in the tree.

**Collections:**

* **`c_connectedGridNodes`**: Child GridNodes connected below this node.
* **`c_connectedGridConnections`**: [GridConnections](grid_connections.md) connected to this node.
* **`c_energyCoops`**: [EnergyCoops](energy_coops.md) at this node.
