# Welcome to the LUX Model Documentation

LUX Energy Twin (LUX for short) is an open-source, interactive, agent based model that simulates energy systems with a focus on electricity and the electricity grid.

Example models to play around with can be found [here](https://lux.energy/en/models) on our website lux.energy 

LUX is built inside [AnyLogic](https://anylogic.help/) a multi-method simulation software platform that supports agent based modelling. A free version of this software called 'Personal Learning Edition' can be downloaded and is able to run the LUX models.

LUX is written almost entirely in Java. The current AnyLogic version used is 8.9.7 and this uses Java 17.

LUX makes use of many public datasets to make sure our models are always enriched with the best data.

## What LUX can and cannot do
* LUX does not simulate current and voltage, only power (kW) and power balance.
* Network lines (cables) are treated as a 'copper plate'. Substations and transformers have limited capacity. This means congestion can only occur at these nodes, not in cables.
* There is no infrastructure for energy carriers other than electricity. It is possible to simulate storages and buffers of other energy carriers, such as heat or hydrogen.
* Our models always have a live simulation that plays when the model first boots up and a rapid run simulation that can simulate headless. The live simulation shows the user direct feedback on his actions like changing scenario's or adding and removing assets. The rapidrun simulation is used to calculate and compare KPIs in a meaningful way.
* The model works in discrete timesteps. The default timestep of the simulation is 15 minute intervals. It is currently not recommend to change this parameter as it is not well tested at different settings. 
The duration of the simulation can be changed, but simulations longer than one year are currently not supported. [^1]

[^1]: Simulations of at least two years are on the development roadmap as current Groepstransportoverenkomsten (GTO) calculations from grid operators are based on the previous two years.

Every LUX model consists of 4 packages.

* Engine: [Docs](engine/overview.md), [Github](https://github.com/Zenmo/zero_engine)
* Loader/Interface: [Docs](loader/overview.md), [Github](https://github.com/Zenmo/zero_Interface-Loader)
* ResultsUI: [Docs](resultsUI/overview.md), [Github](https://github.com/Zenmo/zero_results_UI)
* Project: [Docs](?), [Github](https://github.com/Zenmo/LUX_ProjectTemplate)

The first three are public repositories that need not be altered for standard models. The fourth is a project specific package. These are not made public because of the sensitive data they contain. A template is made available that can be cloned and set up for your own projects.