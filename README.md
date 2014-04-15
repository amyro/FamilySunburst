FamilySunburst
==============

![Sunburst](https://raw.githubusercontent.com/amyro/FamilySunburst/master/examples/overview.png)

A sunburst diagramm to visualise a genealogical tree implemented in Processing. The diagram was designed to visualise a genealogical tree starting from one ancestor (name in the middle). Rings in one colour nuance represent one generation of the family. The inner ring of one colour nuance contains the descendants and the outer ring their partners. The next ring outwards contains the children of the descendants.

![Sunburst](https://raw.githubusercontent.com/amyro/FamilySunburst/master/examples/green.png)

## Adjustment
Sunbursts can be printed in several colours. Textsize, Circle-Radius, Ring-Width and so on can be adjusted as well within the Processing code (see comments on parameters defined at the beginning of each class).


## Database
The family database is stored as a .csv file. Each family member listed in the diagram has an id. Ids need to must from 1 - #familyMembers. It is possible to draw a family tree of a subset of the database by definition of the start id. Besides the name, partner-ids and child-ids are stored for each member. I exported my database from the software Familienbande. The folder Familienbande contains an export template for this software. An example library is contained in the examples folder.





