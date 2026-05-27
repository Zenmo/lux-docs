# Time Series

The class `ZeroTimeSeries` is almost completely analogous to the [Accumulator](accumulators.md) except that it does not require the entries to have the unit kW (any unit can be used).

It is different in the following ways:

* The time series class always stores the full time series as a `double[]` array, whereas this is optional for the accumulator.
* The time series stores only one value per signal resolution entry (no averaging of sub-steps when resolution differs from the simulation timestep — it uses a sample weight instead).
* There is no 'map' variant of the time series object to conveniently store multiple series for different energy carriers or other option lists, as this has not been needed.
* The time series provides `getSum()`, `getSumPos()`, and `getSumNeg()` methods (raw sums of the time series values), whereas the accumulator provides integrals in kWh.

The constructor accepts two arguments:

* **double signalResolution_h**: The resolution of the time series. Must be at least the simulation timestep.
* **double duration_h**: The total duration for which data is stored.

Key methods:

* **`addStep(double value)`**: Adds a data point for the current time step.
* **`getSum()` / `getSumPos()` / `getSumNeg()`**: Returns the sum, positive sum, or negative sum of all values.
* **`getTimeSeries()`**: Returns the underlying `double[]` array.
* **`getMax()` / `getMin()`**: Returns the maximum/minimum value.
* **`getDataSet(double startTime_h)`**: Converts the time series to an AnyLogic DataSet for charting.
* **`add(ZeroTimeSeries zts)` / `subtract(ZeroTimeSeries zts)`**: Element-wise addition/subtraction of time series.

The time series object is used to store simulation results. Compare this to the [profile pointer](profile_pointers.md), which also stores a series of data points, but these are input data like weather data or market prices.