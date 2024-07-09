SET DATEFORMAT 'YMD'

TRUNCATE TABLE bbdd_emilianodelia.omop_cdm.procedure_occurrence;

USE Hosma;

WITH cte AS (
	
	SELECT

		F.IdFichaDMedica10 as procedure_occurrence_id,
		PER.person_iD AS person_id,
		c.concept_id as procedure_concept_id_non_standard, -- from table concept
		convert(date, V.visit_start_date) as procedure_date, 
		convert(datetime, V.visit_start_date) as procedure_datetime, 
		convert(date, V.visit_start_date) as procedure_end_date, 
		convert(datetime, V.visit_start_date) as procedure_end_datetime, 
		32817 as procedure_type_concept_id, -- Provenance of the record (EHR in our case)
		'' as modifier_concept_id, 
		COUNT(*) OVER (PARTITION BY V.VISIT_OCCURRENCE_ID, CIE10.CodigoCIE10) as quantity, -- Count occurrences for each IdAmbulanteReal and CodigoCIE10 as quantity, 
		V.provider_id as provider_id, 
		V.visit_occurrence_id as visit_occurrence_id, 
		'' as visit_detail_id, 
		cie10.CodigoCIE10 as procedure_source_value, 
		CIE10.IdCIE10 as procedure_source_concept_id, 
		1 as modifier_source_value, 

		ROW_NUMBER() OVER (PARTITION BY V.VISIT_OCCURRENCE_ID, c.concept_id ORDER BY F.IdFichaDMedica10) AS rn -- NEEDED TO ONLY KEEP ONE PROCEDURE PER VISIT_OCCURRENCE


	FROM bbdd_emilianodelia.omop_cdm.visit_occurrence v 
					
		JOIN BBDD_EMILIANODELIA.omop_cdm.person per ON per.person_id = V.person_id
		LEFT JOIN Hosma.DBO.DMedica D ON (V.visit_occurrence_id = D.IdEpisodio AND D.TIPOEPISODIO = 'A')
		LEFT JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
		LEFT JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
		LEFT JOIN bbdd_emilianodelia.omop_cdm.concept c on c.concept_code = cie10.codigocie10 

	WHERE 
		V.visit_concept_id LIKE 9202 AND  -- ONLY OP VISITS INCLUDED 
		V.visit_start_date >= '2016-01-01' and 
		V.visit_start_date <= GETDATE() and 
		cie10.TipoCIE10 = 'P' AND -- Only procedures 
		C.DOMAIN_ID LIKE 'PROCEDURE' AND -- ONLY PROCEDURES FROM CONCEPT TABLE
		C.VOCABULARY_ID LIKE 'ICD10PCS' AND -- NECESSARY SO THAT THE JOIN HAPPENS SMOOTHLY
		C.concept_class_id LIKE 'ICD10PCS'

	UNION ALL 

	SELECT

		F.IdFichaDMedica10 as procedure_occurrence_id,
		PER.person_id AS person_id, -- from table person
		c.concept_id as procedure_concept_id_non_standard, -- from table concept
		convert(date, V.visit_start_date) as procedure_date, 
		convert(datetime, V.visit_start_date) as procedure_datetime, 
		convert(date, V.visit_start_date) as procedure_end_date, 
		convert(datetime, V.visit_start_date) as procedure_end_datetime, 
		32817 as procedure_type_concept_id, -- Provenance of the record (EHR in our case)
		'' as modifier_concept_id, 
		COUNT(*) OVER (PARTITION BY V.VISIT_OCCURRENCE_ID, CIE10.CodigoCIE10) as quantity, -- Count occurrences for each IdAmbulanteReal and CodigoCIE10 as quantity, 
		V.provider_id as provider_id, 
		V.visit_occurrence_id as visit_occurrence_id, 
		'' as visit_detail_id, 
		cie10.CodigoCIE10 as procedure_source_value, 
		c.concept_id as procedure_source_concept_id, 
		'' as modifier_source_value, 

		ROW_NUMBER() OVER (PARTITION BY V.VISIT_OCCURRENCE_ID, c.concept_id ORDER BY F.IdFichaDMedica10) AS rn -- NEEDED TO ONLY KEEP ONE PROCEDURE PER VISIT_OCCURRENCE

		FROM bbdd_emilianodelia.omop_cdm.visit_occurrence v 
			JOIN BBDD_EMILIANODELIA.omop_cdm.PERSON PER ON PER.person_id = V.person_id
			LEFT JOIN Hosma.DBO.DMedica D ON (V.visit_occurrence_id = D.IdEpisodio AND D.TIPOEPISODIO = 'I')
			LEFT JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
			LEFT JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
			LEFT JOIN bbdd_emilianodelia.omop_cdm.CONCEPT c on c.concept_code = cie10.codigocie10 

	WHERE 
		V.visit_concept_id LIKE 9201 AND -- ONLY IP VISITS INCLUDED 
		V.visit_start_date >= '2016-01-01' and 
		V.visit_start_date <= GETDATE() and 
		cie10.TipoCIE10 LIKE 'P' AND -- ONLY ICD10 PROCEDURES
		C.DOMAIN_ID LIKE 'PROCEDURE' AND -- ONLY PROCEDURES FROM CONCEPT TABLE
		C.VOCABULARY_ID LIKE 'ICD10PCS' AND -- NECESSARY SO THAT THE JOIN HAPPENS SMOOTHLY
					C.concept_class_id LIKE 'ICD10PCS'
)

INSERT INTO BBDD_EmilianoDelia.omop_cdm.procedure_occurrence(
	procedure_occurrence_id,
	person_id,
	procedure_concept_id, 
	procedure_date, 
	procedure_datetime, 
	procedure_end_date, 
	procedure_end_datetime, 
	procedure_type_concept_id, 
	modifier_concept_id, 
	quantity, 
	provider_id, 
	visit_occurrence_id, 
	visit_detail_id, 
	procedure_source_value, 
	procedure_source_concept_id, 
	modifier_source_value)

SELECT DISTINCT 
	procedure_occurrence_id,
	person_id,
	cr.concept_id_2 as procedure_concept_id, 
	procedure_date, 
	procedure_datetime, 
	procedure_end_date, 
	procedure_end_datetime, 
	procedure_type_concept_id,
	modifier_concept_id, 
	quantity, 
	provider_id, 
	visit_occurrence_id, 
	visit_detail_id, 
	procedure_source_value, 
	procedure_source_concept_id, 
	modifier_source_value

FROM cte temp
left join BBDD_EmilianoDelia.omop_cdm.CONCEPT_RELATIONSHIP cr on cr.concept_id_1 = temp.procedure_concept_id_non_standard

WHERE RN = 1 and cr.relationship_id like 'maps to'