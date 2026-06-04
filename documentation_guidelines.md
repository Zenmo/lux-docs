# Documentation Guidelines

This document is aimed to help you create documentation pages that match the structure and style of our docs. \
The documentation is in markdown files \( \.md \), the basic syntax of which can be found [here](https://www.markdownguide.org/basic-syntax/)

## What should be documented?

Any sufficiently important Agent, Class or Function in the LUX model. The scope of the LUX model is: the engine, loader, interface, resultsUI and projectTemplate. 

Sufficiently important is ofcourse a subjective statement, but as a rule of thumb: 

> If a piece of code is of vital importance to the workings of the model, or contains assumptions that have significant impact on the model results it should be documented.

## Structure of a documentation page

All documentation pages should try to follow the same structure. The page should contain at least the following information:

* A (short) introduction on the piece of code. How does it fit into the model's architecture. What function does it fulfil in the model. 
* If it is a class or agent, what are the most important parameters & variables? For each of those describe why it is of importance. You may also want to describe where the choice of parameter is determined or where it is used by the class.
* If it is a class or agent, what are the most important functions & methods? For each of those describe why it is of importance.

## Styling

* Every page should start with a title, which is added by starting a line with a \# (Level 1 heading).
* A page may contains paragraphs, which are added by lines starting with \#\# (Level 2 heading).
* Small code snippits that fit inline and names of variables, classes, functions, etc. must be displayed between backticks \( \` \) \
For example: `p_timeVariables.updateTimeVariables(v_timeStepsElapsed, p_timeParameters);`
* Larger code snippits that span multiple lines must be displayed as fenced code blocks between three backticks \( \`\`\` \) \
You can also specify the language of the code after the first three backticks, e.g. \`\`\`java \
The result looks like this:
```java
for (GridConnection gc : c_gridConnections) {
    		gc.f_calculateEnergyBalance(p_timeVariables, v_isRapidRun);
}
```
* Functions discriptions are code snippits, hence displayed between backticks. \
Functions may list all their arguments, some of their arguments, or none of their arguments. \
Arguments that are omitted are replaced with three dots \( \.\.\. \) \
Usually from the arguments both the type and name is mentioned, the variable name is only mentioned in larger code snippits where it is relevant or when there is ambiguity , so not in function descriptions. \
For example in `J_RapidRunData`: `addTimeStep( J_FlowsMap fm_currentBalanceFlows_kW, J_FlowsMap fm_currentConsumptionFlows_kW, ... , J_TimeVariables timeVariables)`
