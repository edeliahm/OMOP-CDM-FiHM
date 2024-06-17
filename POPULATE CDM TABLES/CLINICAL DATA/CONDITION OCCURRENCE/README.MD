## LOGIC BEHIND THE QUERY 
* We document conditions using ICD10 codes fop Inpatient and Outpatient Visits 
* Internally we have our own version of __CONDITION_OCCURRENCE_IDs__ so this column was reused for the sake of simplicity within the ETL
* Every ICD10 code per medical event was matched with its corresponding OMOP __STANDARD_CONCEPT_ID__ using the __CONCEPT_RELATIONSHIP__ table 
