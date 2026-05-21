# Accumulator Maps

Accumulator Maps are a data structure that stores a set of [accumulators](accumulators.md).

The constructor of the accumulator map takes an EnumClass or [OptionList](../option_lists.md) as an argument.

It is then possible to fill the map with accumulators for a (subset) of the options with the method createEmptyAccumulators().
Individual accumulators can also be added with the put() method.

Accumulators can be retrieved with the get() method.

Just like the accumulator it is possible to add or subtract accumulator maps.
It is also possible to turn the accumulators into datasets. This returns a [DataSetMap](dataset_maps.md) object. This requires to specify the start time as datasets store both X and Y values.

It is also possible to get a dataset with a smaller signal resolution than the accumulators, given that it is a divisor of the original signal resolution.