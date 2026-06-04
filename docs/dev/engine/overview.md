# Engine

The engine is the main component of the simulation software. 

The engine contains the needed classes to input a full description of the energy system, as well as the tools to run simulations. This includes the decision making algorithms that decide the behaviour of agents as well as the data structures to store all the results of a simulation.

The main agent of the engine is called the [EnergyModel](energy_model.md).
This agent contains all other agent populations, like all the [GridConnections](grid_connections.md) and [GridNodes](grid_nodes.md).
The EnergyModel is also where all the energy flows of all agents living in the model accumulate. 

The populations of agents in the engine are filled by the [loader](../loader/overview.md). 

The engine runs two types of simulations:
* Live Simulation
* RapidRun Simulation

The live simulation serves to give direct feedback to user inputs in the [interface](../interface/overview.md). The rapidrun simulation is used to compare model results and KPIs between different scenarios. 