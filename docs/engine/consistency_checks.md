# Consistency Checks

The LUX engine applies several consistency checks to ensure a correct model.

## Configuration Check

The configuration check validates the model setup before simulation. It is implemented as `f_checkConfiguration()` methods on the [EnergyModel](energy_model.md) and [GridConnections](grid_connections.md).

The EnergyModel's `f_checkConfiguration()` iterates over all GridConnections and calls their individual check.

The GridConnection's `f_checkConfiguration()` checks for:

* **Flex assets without an EMS**: If a GridConnection has flexible assets (`c_flexAssets`) but no `I_EnergyManagement` (EMS) is configured, a `RuntimeException` is thrown.
* **EMS-level validation**: If an EMS is present, the check is delegated to the EMS's own `checkConfiguration()` method. Each EMS implementation validates that the set of flex assets matches its expected types.

This ensures that every agent with flexible assets has a valid control system assigned before the simulation runs.

## Energy Balance Check

The energy balance check (implemented as `f_performEnergyBalanceCheck()` on the EnergyModel) verifies the law of conservation of energy: energy cannot be created or destroyed in the model.

Energy can only enter or leave the model through these paths:

* **Import** of energy carriers.
* **Export** of energy carriers.
* **Primary production**: Energy harvested from the environment (e.g. wind, solar irradiation, ambient heat absorbed by buildings).
* **Final consumption**: Energy that leaves the system as losses (dissipated heat, conversion losses, consumption profiles).

The balance equation is:

```math
Production - Export = Consumption - Import
```

In code, the check computes:

```java
double energyBalanceCheck_MWh = totalImport_MWh + totalProduction_MWh
    - (totalExport_MWh + totalConsumption_MWh + totalDeltaStoredEnergy_MWh);
```

This value must be zero. If it exceeds a tolerance of 1e-6 MWh, a warning is logged. The check also accounts for changes in stored energy (battery charge state, thermal storage in buildings) to prevent false positives from energy buffers that the same at the end of the simulation compared to the start.