# GridNodes

GridNodes are part of either the electricity or heatgrid in a LUX model, depending on which energycarrier is entered in the parameter p_energyCarrier. 

GridNodes are always part of a tree. The model does not support rings.

GridNodes contain information such as:

* p_gridNodeID: A unique string to identify the gridnode. Usually T0, T1, T2, etc.
* p_capacity_kW: A double that represents the symmetrical capacity of the gridnode. 
* p_realCapacityAvailable: a boolean that signifies if the capacity is known or estimated.
* gisRegion: A GIS region to allow the gridnode to be rendered as a shape on the GIS map.
* p_parentNodeID: The p_gridNodeID of the node above this node.
* c_connectedGridNodes: A collection of GridNodes that this node is a parent of.
* c_connectedGridConnections: A collection of GridConnections that are connected to this node.
