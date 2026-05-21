# Time Series

The class ZeroTimeSeries is almost completely analogous to the [Accumulator](accumulators.md) except that does not require the entries to have the unit kW. 

It is different in the following ways:

* The timeseries class must store the timeSeries, whereas this is optional for the accumulator.
* There is no 'map' variant of the timeSeries object to conveniently store multiple series for different energycarriers or other option lists as this has not been useful.

The time series object is used to store simulation results, compare that to the [profile pointer](profile_pointers.md) which also stores a series of data points, but these are input data like weather data or market prices.