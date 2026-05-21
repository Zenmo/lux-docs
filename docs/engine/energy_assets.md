# Energy Assets

EnergyAssets are a core class in the LUX model. Everything that produces, consumes or converts energy in the model is an energy asset. The energy assets in the model have a hierarchical structure. At the top of the tree is the distinction between J_EAFixed and J_EAFlex.

Fixed assets are assets that have predetermined behaviour. These are 'profiles' that are played during the simulation. An example for a fixed asset is the baseload consumption of a household or the production of a solar panel. There can be flexibility in these assets, for example by curtailing the solar power, but a priori there is none.

Flex assets are assets that require, at every timestep, to be told at what power they are operated. This decision is made by an [EMS](energy_management_systems.md) 

The full tree of the hierarchical structure of energy assets can be seen in image X.

Energy assets have two important [option lists](option_lists.md):

* energyAssetType: This determines the category of the energy asset. This optionlist can seem redundant[^1] because of the different classes, but allows us to use data such as profiles of EV charging sessions and keep the bookkeeping consistent with simulated J_EAEVs. 
* assetFlowCategory: This determines under which category the energy flows of this asset fall in the graphs and charts

[^1]: We are actually trying to remove the optionlist OL_EnergyAssetType, because it has exploded too much in size and are currently looking into ways to split this into multiple smaller option lists like OL_ProductionType, OL_VehicleType, etc.

When energyassets are created they register themselves at their [GridConnection](grid_connections.md) through the method registerEnergyAsset(). 

At every timestep the assets are operated through the method f_updateAllFlows().

At the start of a rapidrun the current state of the asset in the live simulation is stored with the method storeStatesAndReset(), at the end of the headless run the states are restored through restoreStates().

Energy assets also keep track of a variable called 'EnergyUsed_kWh', this variable contains all the energy losses of the asset. At the end of a rapidrun simulation these losses are compared to the bookkeeping of the gridconnection and energymodel to make sure no energy has disappeared or is created out of thin air. See also [Consistency Checks](consistency_checks.md)

