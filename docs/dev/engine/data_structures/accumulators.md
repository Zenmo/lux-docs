# Accumulators

Accumulators are a datastructure created to be able to efficiently store data results of rapidrun simulations. 

The unit of data inside accumulators is always kW. The accumulator has public methods to inquire about kWh totals (integrals), minima/maxima and a method to convert the timeseries to an AnyLogic DataSet (to render charts / graphs).

For a data structure to store data with other units see [time series](time_series.md)

There also exist methods to add and subtract accumulators from eachother.

The constructor accepts three arguments:

* **boolean hasTimeSeries**: When this boolean is set to true the accumulator will store the entire timeseries. When the boolean is set to false the accumulator will only store specific data about the timeseries, such as the minimum, maximum, and total. 
* **double signalResolution_h**: This parameter specifies the resolution of the timeseries. The timeseries will store a datapoint for each signalResolution_h. This value must be at least the timestep of the energymodel (15 minutes by default) and can be at most the duration_h. It must also be a divisor of duration_h. 
* **double duration_h**: The total duration of which we are storing data. For an accumulator that stores data for an entire year this would be 8760 hours, for an accumulator that stores data about one week this would be 672 hours.

Every timestep the method addStep should be called with the current power in kW. This method then handles the timeseries and signal resolution.