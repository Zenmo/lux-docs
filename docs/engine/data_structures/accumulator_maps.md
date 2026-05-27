# Accumulator Maps

Accumulator Maps store a set of [accumulators](accumulators.md) keyed by an enum type. The implementation is class `J_AccumulatorMap<E extends Enum<E>>`. During the simulation the results are stored in these accumulators. Agents loop over their energy carriers, asset flow categories or other option list and the individual accumulators are accessed and updated.

The constructor takes one argument:

* **Class\<E\> enumClass**: The enum type that defines the possible keys.

Key methods:

* **`createEmptyAccumulators(EnumSet<E> selectedFlows, boolean hasTimeSeries, double signalResolution_h, double duration_h)`**: Fills the map with accumulators for the given subset of enum keys. All accumulators are created with the same parameters.
* **`put(E key, ZeroAccumulator acc)`**: Adds an individual accumulator for a specific key.
* **`get(E key)`**: Retrieves the accumulator for a given key.
* **`getClone()`**: Returns a deep clone of this map, cloning each accumulator.
* **`reset()`**: Resets all accumulators in the map.
* **`clear()`**: Removes all accumulators from the map.
* **`keySet()`**: Returns the set of keys that have accumulators.
* **`add(J_AccumulatorMap<E> accumulatorMap)`**: adds the accumulators of another accumulator map to the accumulators of this map and returns this object.
* **`subtract(J_AccumulatorMap<E> accumulatorMap)`**: subtracts the accumulators of another accumulator map to the accumulators of this map and returns this object.


Accumulator maps can be converted to [DataSetMaps](dataset_maps.md) via `getDataSetMap(startTime_h)` or `getDataSetMap(startTime_h, dataSetSignalResolution_h)`. The latter allows downsampling to a coarser signal resolution, given that it is a multiple of the accumulator's resolution.