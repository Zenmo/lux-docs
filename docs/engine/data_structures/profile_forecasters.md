# Profile Forecasters

Profile Forecasters compute a rolling average forecast over a [profile pointer](profile_pointers.md). The implementation is class `J_ProfileForecaster`.

A forecaster takes a profile pointer and computes the average value over a configurable forecast horizon. As the simulation progresses, the forecast window slides forward and the average is updated incrementally.

The constructor accepts the following arguments:

* **String forecastName**: An optional name for this forecaster. If null, it is automatically generated from the profile pointer name and forecast horizon.
* **J_ProfilePointer profilePointer**: The underlying profile to forecast over.
* **double forecastTime_h**: The length of the forecast horizon in hours.
* **double currentTime_h**: The current simulation time used for the initial forecast calculation.
* **double timeStep_h**: The simulation time step, used to determine the number of samples in the forecast window.

Key methods:

* **`initializeForecast(double currentTime_h)`**: Computes the initial forecast as the average of all profile values from `currentTime_h` to `currentTime_h + forecastTime_h`.
* **`updateForecast(double t_h)`**: Updates the forecast by removing the contribution of the value at `t_h` and adding the contribution of the value at `t_h + forecastTime_h` (sliding window).
* **`getForecast()`**: Returns the current forecasted average value.
* **`getForecastTime_h()`**: Returns the length of the forecast horizon.
* **`getName()`**: Returns the name of this forecaster.

The sliding window update in `updateForecast` is efficient: it only needs two profile lookups per timestep rather than recomputing the entire average.