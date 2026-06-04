# Value Maps

Value Maps are a generic data structure for storing a `double` value for each key in an enum set. The implementation is class `J_ValueMap<E extends Enum<E>>`.

Internally the values are stored in a flat array indexed by the enum ordinal. An `EnumSet` tracks which keys have been set. This makes value maps more memory-efficient and faster than using a `HashMap` or `EnumMap`.

The constructor accepts the enum `Class`:

* **Class\<E\> enumClass**: The enum type that defines the possible keys. All enum constants are pre-allocated in the internal array.

The following methods are available:

* **`get(E key)`**: Returns the current value for the given key.
* **`put(E key, double value)`**: Sets the value for the given key.
* **`addFlow(E key, double value)`**: Adds `value` to the existing value for the key.
* **`addFlows(J_ValueMap f)`**: Adds all values from another value map.
* **`removeFlows(J_ValueMap f)`**: Subtracts all values from another value map.
* **`cloneMap(J_ValueMap flowMap)`**: Copies all values from another map.
* **`clear()`**: Resets all values to zero.
* **`totalSum()`**: Returns the sum of all values.

Value Maps are similar to [Flows Maps](flows_maps.md), but are generic over any enum type, whereas flows maps are specifically for `OL_EnergyCarriers`.