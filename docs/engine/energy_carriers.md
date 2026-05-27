# Energy Carriers

The energycarriers in LUX are found in the optionlist OL_EnergyCarriers in the engine. 
By default this optionlist contains the following energycarriers:

* Electricity
* Heat
* Methane
* Petroleum_fuel
* Hydrogen
* Iron_powder

Other energycarriers can be easily added to the optionlist.
All the datastructures, such as the [accumulators](data_structures/accumulators.md) in maps in the rapidrundata, that store data for charts and graphs are dynamically extended to include these new energycarriers.
The engine keeps track of which energycarriers are used in the model. This is done through the EnumSets activeProductionEnergyCarriers and activeConsumptionEnergyCarriers in the energy assets.