# Energy Cooperatives

Energy cooperatives (or EnergyCoops for short) have two separate use cases in the engine.

* The traditional meaning: a community-owned cooperative that offers a sustainable, community-focused alternative to traditional energy providers.
* As a collection of [GridConnections](grid_connections.md), usually businesses, that form an **Energy Hub** to share energy and/or contracted capacity.

The `EnergyCoop` agent implements `I_EnergyData`, exposing rapid-run and live data for results visualization. It extends the `Actor` class.

**Key fields:**

* **`c_memberGridConnections` / `c_customerGridConnections`**: GridConnections belonging to the cooperative as members (producers) or customers (consumers). In an E-Hub all gridconnections are members.
* **`f_calculateEnergyBalance`**: This function is the main part of the engine loop every timestep. It resets the energy flows, loops through the coop members and customers to aggregate the energy flows. Then it stores the results in either the live data or rapidrun data class.
* **`f_operateAggregatorEnergyManagement`**: This function is called by the energymodel after all gridconnections have operated their assets and will determine the behaviour for the aggregated assets for the next timestep. This means aggregated assets in an EnergyCoop will always have one timestep delay in their behaviour.

The EnergyCoop agent allows for a centralized [EMS](energy_management_systems.md) that takes control from individual GridConnections and manages all (or a subset of) the flexible assets from a single point. This allows members of an Energy Hub to use more of their existing connection capacities or increase their combined self-consumption.

An example of an Energy Cooperative model developed with LUX is the [Cooperatie Configurator](https://coco.local4local.nu/). Models about Energy Hubs are usually restricted in their access because of the sensitive company data.