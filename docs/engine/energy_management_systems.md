# Energy Management Systems

The Energy Management System (EMS) lives inside each [GridConnection](grid_connections.md) and decides what all the flexible assets do at every timestep. The interface is `I_EnergyManagement`.

There are three built-in implementations:

### J_EnergyManagementDefault

The default EMS that delegates to external sub-managers, calls them in the following order each timestep:

1. **Heating** (`I_HeatingManagement`) — controls heat pumps and heating systems.
2. **Charging** (`I_ChargingManagement`) — manages EV charging sessions.
3. **Battery** (`I_BatteryManagement`) — operates stationary battery storage.
4. **Backup Generator** (`I_BackupGeneratorManagement`) — runs backup generators if needed.
5. **Curtailment** (`I_CurtailManagement`) — curtails production when required.

### Custom EMS

You can implement your own EMS by implementing the `I_EnergyManagement` interface. The interface specifies:

* **`manageFlexAssets(J_TimeVariables)`**: The main scheduling method called each timestep.
* **`checkConfiguration(List<J_EAFlex>)`**: Validates that the set of flex assets is compatible with this EMS.
* **`getInternalAssetManagements()` / `getSupportedExternalAssetManagements()` / `getActiveExternalAssetManagements()`**: Provide and track the allowed sub-managers.
* **`setExternalAssetManagement(...)` / `removeExternalAssetManagement(...)`**: Add or remove sub-managers dynamically.

Each EMS has a certain **incentive** — for example maximizing self-consumption from solar panels or reducing peak import from the grid. Systems can also differ in their approach: some decide at every timestep what to do in that same timestep, while others make a schedule based on a forecast. 