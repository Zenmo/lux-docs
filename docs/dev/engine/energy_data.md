# EnergyData

I_EnergyData is an interface implemented by three agents:

* [GridConnections](grid_connections.md)
* [EnergyCoops](energy_coops.md)
* [EnergyModel](energy_model.md)

The interface specifies 4 methods:
* getLiveData()
* getRapidRunData()
* getPreviousRapidRunData()
* getScope()

This allows the [resultsUI](../resultsUI/overview.md) to request data for charts and graphs from different agents in the engine in a standerdized method.

The data stored in [GridNodes](grid_nodes.md) and their available charts differ too much to be included in this list.

The agent EnergyDataViewer is used when debugging to inspect the data in the live and rapidrun classes. A button labeled 'View Data' is available on the canvasses of the three agents to take fill the data viewer and navigate to it.