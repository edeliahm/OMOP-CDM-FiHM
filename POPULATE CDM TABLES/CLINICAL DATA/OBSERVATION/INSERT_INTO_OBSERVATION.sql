TRUNCATE TABLE bbdd_emilianodelia.omop_cdm.observation;

SET DATEFORMAT 'YMD';

USE Hosma;

WITH cte AS (

SELECT 

    f.IdFichaDMedica10 AS observation_id, 
    per.person_id AS person_id, 
    cr.concept_id_2 AS observation_concept_id,
    TRY_CONVERT(DATE, V.visit_start_date) AS observation_date,
    TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, V.visit_start_date)) + ' ' + '00:00:00.000' AS observation_datetime, 
    32817 AS observation_type_concept_id, -- WE OBTAIN ALL OF OUR RECORDS FROM EHR FILES 
    '' AS value_as_number, -- value of the Result of the Observation, if applicable and available. It is not expected that all Observations will have numeric results
    '' AS value_as_string, -- SAME AS BEFORE, SOMETIMES A RESULT FROM A TEST CAN BE REPRESENTED AS CATEGORICAL VARIABLE 
    CASE WHEN cr.concept_id_2 IS NULL THEN 0 ELSE CR.concept_id_2 END AS value_as_concept_id, 
    '' AS qualifier_concept_id, 
    '' AS unit_concept_id, 
    v.provider_id AS provider_id, 
    v.visit_occurrence_id AS visit_occurrence_id, 
    '' AS visit_detail_id, 
    cie10.CodigoCIE10 AS observation_source_value, 
    c.concept_id AS observation_source_concept_id, 
    '' AS unit_source_value, 
    '' AS qualifier_source_value, 
    '' AS value_source_value, 
    '' AS observation_event_id, 
    '' AS obs_event_field_concept_id
    
FROM bbdd_emilianodelia.omop_cdm.visit_occurrence v

	JOIN BBDD_EMILIANODELIA.omop_cdm.person per ON per.person_id = V.person_id
	JOIN Hosma.DBO.DMedica D ON (V.visit_occurrence_id = D.IdEpisodio AND D.tipoepisodio = 'I')
	JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
	JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
	JOIN bbdd_emilianodelia.omop_cdm.CONCEPT c ON c.concept_code = cie10.codigocie10 AND c.domain_id LIKE 'observation'
	JOIN BBDD_EmilianoDelia.omop_cdm.CONCEPT_RELATIONSHIP cr ON cr.concept_id_1 = c.concept_id AND cr.relationship_id LIKE 'maps to'

WHERE 

		v.visit_concept_id LIKE 9201  
    AND TRY_CONVERT(DATE, v.visit_start_date) >= '2016-01-01' 
    AND TRY_CONVERT(DATE, v.visit_end_date) <= GETDATE()

UNION ALL 

SELECT 

    f.IdFichaDMedica10 AS observation_id, 
    per.person_id AS person_id, 
    cr.concept_id_2 AS observation_concept_id,
    TRY_CONVERT(DATE, V.visit_start_date) AS observation_date,
    TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, V.visit_start_date)) + ' ' + '00:00:00.000' AS observation_datetime, 
    32817 AS observation_type_concept_id, -- WE OBTAIN ALL OF OUR RECORDS FROM EHR FILES 
    '' AS value_as_number, -- value of the Result of the Observation, if applicable and available. It is not expected that all Observations will have numeric results
    '' AS value_as_string, -- SAME AS BEFORE, SOMETIMES A RESULT FROM A TEST CAN BE REPRESENTED AS CATEGORICAL VARIABLE 
    CASE WHEN cr.concept_id_2 IS NULL THEN 0 ELSE CR.concept_id_2 END AS value_as_concept_id,  --may be provided through mapping from a source Concept which contains the content of the Observation. In those situations, the CONCEPT_RELATIONSHIP table in addition to the "Maps to" record contains a second record with the relationship_id set to "Maps to value".
    '' AS qualifier_concept_id, 
    '' AS unit_concept_id, 
    v.provider_id AS provider_id, 
    v.visit_occurrence_id AS visit_occurrence_id, 
    '' AS visit_detail_id, 
    cie10.CodigoCIE10 AS observation_source_value, 
    c.concept_id AS observation_source_concept_id, 
    '' AS unit_source_value, 
    '' AS qualifier_source_value, 
    '' AS value_source_value, 
    '' AS observation_event_id, 
    '' AS obs_event_field_concept_id

FROM bbdd_emilianodelia.omop_cdm.visit_occurrence v

	JOIN bbdd_emilianodelia.omop_cdm.person per ON per.person_id = v.person_id
	JOIN Hosma.DBO.DMedica D ON (v.visit_occurrence_id = D.IdEpisodio AND D.tipoepisodio = 'A')
	JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
	JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
	JOIN bbdd_emilianodelia.omop_cdm.concept c ON c.concept_code = cie10.codigocie10 AND c.domain_id LIKE 'observation'
	JOIN bbdd_emilianodelia.omop_cdm.concept_relationship cr ON cr.concept_id_1 = c.concept_id AND cr.relationship_id LIKE 'maps to'
	
WHERE 

	    V.visit_concept_id LIKE 9202 
	AND TRY_CONVERT(DATE, V.visit_start_date) >= '2016-01-01'
	AND TRY_CONVERT(DATE, V.visit_start_date) <= GETDATE()
)

INSERT INTO bbdd_emilianodelia.omop_cdm.observation(
	observation_id, 
	person_id, 
	observation_concept_id, 
	observation_date,
	observation_datetime, 
	observation_type_concept_id, 
	value_as_number, 
	value_as_string, 
	value_as_concept_id, 
	qualifier_concept_id, 
	unit_concept_id, 
	provider_id, 
	visit_occurrence_id, 
	visit_detail_id, 
	observation_source_value, 
	observation_source_concept_id,
	unit_source_value, 
	qualifier_source_value, 
	value_source_value, 
	observation_event_id, 
	obs_event_field_concept_id)

SELECT
	observation_id, 
	person_id, 
	observation_concept_id, 
	observation_date,
	observation_datetime, 
	observation_type_concept_id,
	value_as_number, 
	value_as_string, 
	value_as_concept_id, 
	qualifier_concept_id, 
	unit_concept_id, 
	provider_id, 
	visit_occurrence_id, 
	visit_detail_id, 
	observation_source_value, 
	observation_source_concept_id,
	unit_source_value, 
	qualifier_source_value, 
	value_source_value, 
	observation_event_id, 
	obs_event_field_concept_id

FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY observation_id ORDER BY (SELECT NULL)) AS rn 
    FROM cte

) AS sub
WHERE rn = 1