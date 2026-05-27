# Flows Maps

Flows Maps are a data structure to store energy flows per [energy carrier](../energy_carriers.md). The implementation is class `J_FlowsMap`.

This data structure is used throughout the simulation to pass flow values at each timestep. For example, the current balance flows, consumption flows, and production flows are all stored as `J_FlowsMap` objects.

Internally the values are stored in a fixed-size `double` array indexed by the ordinal of `OL_EnergyCarriers`. An `EnumSet` tracks which carriers have been set, providing faster iteration than iterating over all possible carriers.

The constructor takes no arguments:

* **Default constructor**: Prepares an empty flows map with all energy carrier slots initialized to zero.

The following methods are available:

* **`get(OL_EnergyCarriers key)`**: Returns the flow value for the given energy carrier.
* **`put(OL_EnergyCarriers key, double value)`**: Sets the flow value for a carrier.
* **`addFlow(OL_EnergyCarriers key, double value)`**: Adds `value` to the existing flow for a carrier.
* **`addFlows(J_FlowsMap f)`**: Adds all flows from another flows map.
* **`removeFlows(J_FlowsMap f)`**: Subtracts all flows from another flows map.
* **`cloneMap(J_FlowsMap flowMap)`**: Copies all values from another map.
* **`clear()`**: Resets all values to zero.
* **`totalSum()`**: Returns the sum of all flows.

### Reduced Flows Map

There is also a `J_ReducedFlowsMap` that extends `EnumMap<OL_EnergyCarriers, Double>`. It overrides `get(Object key)` to return `0.0` instead of `null` for unset keys. It provides the same `addFlow()` and `addReducedFlows()` convenience methods and is used for aggregating flows from multiple `J_FlowsMap` objects.

For a generic version of this data structure (not restricted to `OL_EnergyCarriers`) see [value maps](value_maps.md).