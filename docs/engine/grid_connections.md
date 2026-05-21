# GridConnections

GridConnections are agents that represent a connection to the grid. These are usually homes or companies, but could also be solar fields, windmills, charging stations, large scale batteries or districtheating heat sources.

GridConnections contain information such as:

* p_gridConnectionID: A unique string to identify the gridconnection.
* p_address: A class that contains things such as postalcode, streetname, housenumber etc.
* v_liveConnectionMetaData: A class that contains thing such as the contracted delivery/feed in capacity, the physical capacity and wether or not this information is known or estimated.
* c_connectedGISObjects: A collection of GIS_Objects. These objects contain the GIS regions to allow the gridconnections to be rendered in shapes on the GIS map.
* p_owner: The ConnectionOwner of the gridconnection. 

GridConnections also contain energy assets. These are managed by the Energy Management System (EMS) of the gridconnection. 
The method f_updateFlexAssetFlows is called by the EMS to operate the energy assets.
The methods f_connectToJ_EA and f_removeTheJ_EA are used to add and remove energy assets to the gridconnections. 

The method f_calculateEnergyBalance is part of the 'main' loop. This method is called by the EnergyModel at every timestep. This method resets all values that store information about a timestep and then goes on to manage and operate all the assets in the gridconnection.

The method f_connectionMetering is called at the end of the f_calculateEnergyBalance. This method checks if there is a heat unbalance on the gridconnection. A heat unbalance is not allowed and this would cause the simulation to stop. If everything is okay the function goes on to store the data about this timestep in either the live of rapidrun data classes.

