# DataSet Maps

DataSet Maps store a set of [AnyLogic DataSets](https://anylogic.help/anylogic/analysis/data-set.html) (2D XY data) keyed by an enum type. The implementation is class `J_DataSetMap<E extends Enum<E>>`.

DataSet Maps are typically created from [accumulator maps](accumulator_maps.md) via `getDataSetMap(startTime_h)`, which converts each accumulator's time series to an AnyLogic DataSet for rendering charts and graphs.

The constructor accepts one argument:

* **Class\<E\> enumClass**: The enum type that defines the possible keys.

Key methods:

* **`createEmptyDataSets(EnumSet<E> selectedFlows, int size)`**: Creates empty DataSets for the given subset of enum keys.
* **`put(E key, DataSet ds)`**: Associates a DataSet with the given key.
* **`get(E key)`**: Retrieves the DataSet for a given key.
* **`clear()`**: Removes all DataSets.
* **`keySet()`**: Returns the set of keys that have associated DataSets.
