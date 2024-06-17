## LOGIC BEHIND THE QUERY 
* For this table we received support documents from TrinetX. They performed this mapping exercise upon our data a couple of years ago and were happy to share the documentation of reference with us 
* The csv file included in this folder contains the national code for each medicine or ingredient avaiable in our systems at the time of the mapping and their OMOP standard equivalent 
* Given this there was no need to use the __CONCEPT_RELATIONSHIP__ table 
* There was something peculiar in our systems. Sometimes the national code was not the in the right format and the last digit needed to be removed in order for the JOIN to be performed correctly
* The csv file of reference was uploaded into SQLServer to make the JOIN process more seamless 
