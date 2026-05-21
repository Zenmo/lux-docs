# Energy Management Systems

The energy management system (EMS) is a class that lives inside GridConnections that decides what all the flexible assets do at every timestep. 

There are many different systems to choose from. You can also implement your own custom EMS.

Each EMS has a certain 'incentive'. This could be for example: maximizing your selfconsumption from your solar panels, reducing the peak import from the grid or 

Energy management systems can also differ in their approach to this optimization. Some systems decide at every timestep what to do in this same timestep. Other systems make a schedule based on a forecast. 