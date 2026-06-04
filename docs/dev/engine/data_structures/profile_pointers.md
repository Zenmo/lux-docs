# Profile Pointers

Profile Pointers provide access to time-series input data, such as weather profiles (temperature, irradiance, wind speed) or market prices. The implementation is class `J_ProfilePointer`.

Unlike [Accumulators](accumulators.md) and [Time Series](time_series.md) which store simulation *results*, profile pointers read pre-defined input profiles. The profile data is stored as a `double[]` array with a fixed timestep.

The constructor accepts the following arguments:

* **String name**: A descriptive name for this profile (e.g. "ground_temperature", "day_ahead_electricity_price").
* **double[] profile**: The array of data values.
* **double dataTimeStep_h**: The time step between consecutive values in the profile array.
* **double dataStartTime_h**: The start time of the first profile entry, relative to 00:00 on January 1st of the simulation year.
* **OL_ProfileUnits profileUnits**: The physical unit of the profile values.

Key methods:

* **`getCurrentValue()`**: Returns the most recently updated value.
* **`getValue(double time_h)`**: Returns the profile value at the given simulation time. Supports profile looping: when `enableProfileLooping` is true (default), indices beyond the array length wrap around using modular arithmetic.
* **`updateValue(double t_h)`**: Calls `getValue(t_h)` and stores the result internally.
* **`getAllValues()`**: Returns a clone of the full profile array.
* **`getDataTimeStep_h()`**: Returns the time step of the profile data.

The `updateValue` / `getCurrentValue` pattern is used each timestep, called by the [EnergyModel](../energy_model.md) for all profile pointers during the simulation to avoid repeated index calculations.

For forecasting over a profile, see [profile forecasters](profile_forecasters.md).