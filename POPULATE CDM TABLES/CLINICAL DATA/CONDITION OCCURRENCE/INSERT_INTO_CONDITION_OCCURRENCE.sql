
SET DATEFORMAT 'YMD'

TRUNCATE TABLE BBDD_EmilianoDelia.OMOP_CDM.CONDITION_OCCURRENCE

USE Hosma;

WITH cte AS (

SELECT DISTINCT
	
	f.IdFichaDMedica10 as condition_occurrence_id, --each instance of a condition present should be assigned a unique key (already done internally)
	PER.person_id as person_id, 
	C.concept_id as ICD10_condition_concept_id, 

	/* Most often data sources do not have the idea of a start date for a condition. 
		Rather, if a source only has one date associated with a condition record it is 
		acceptable to use that date for both the CONDITION_START_DATE and the CONDITION_END_DATE.*/

	CONVERT(DATE, V.visit_start_date) AS condition_start_date, 
	CONVERT(VARCHAR, CONVERT(DATE, V.visit_start_date)) + ' ' + '00:00:00.000' AS condition_start_datetime, 
	CONVERT(DATE, V.visit_start_date) AS condition_end_date, 
	CONVERT(VARCHAR, CONVERT(DATE, V.visit_start_date)) + ' ' + '00:00:00.000' AS condition_end_datetime, 
	32817 as condition_type_concept_id, -- INDICATES WHERE THE RECORD COMES FROM, IN OUR CASE IS ALWAYS EHR (ELECTRONIC HEALTH RECORD)
	CASE 
		/*When the Dx is marked as primary this always means that the Dx was present in the episode */
		WHEN f.Tipo = 'P' THEN 32901 -- Vocab: Condition Status / Admission Diagnosis 
		/*When the Dx is secondary but is also present in the episode  */
		WHEN f.Tipo ='S' AND f.POAD = 'S' THEN 32907 -- Vocab: Condition Status / Secondary Admission Diagnosis
		/* Any other classifications of a secondary Dx belongs as a plain Secondary Dx*/
	ELSE 32908 -- Vocab: Condition Status / Secondary Diagnosis  as condition_status_concept_id, 
	END AS condition_status_concept_id, 
	'' AS stop_reason, 
	V.provider_id AS provider_id, 
	V.visit_occurrence_id AS visit_occurrence_id, 
	'' AS visit_detail_id, 
	cie10.CodigoCIE10 AS condition_source_value, -- source value can be a ICD10 code 
	c.concept_id AS condition_source_concept_id, 
	CASE
		WHEN f.Tipo LIKE 'P' AND F.POAD LIKE 'S'THEN 'Dx Primario Presente en el momento del Episodio'
		WHEN F.Tipo LIKE 'P' AND F.POAD LIKE 'D' THEN 'Dx Primario / Documentación insuficiente para determinar si la condición esté presente o no al momento del episodio'
		WHEN F.Tipo LIKE 'P' AND F.POAD LIKE 'E' THEN 'Dx Primario Exento de Informar POA'
		WHEN f.Tipo LIKE 'p' and F.POAD LIKE 'N' THEN 'Dx Primario No presente en el episodio'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'S' THEN 'Dx Secundario Presente en el Ingreso'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'I' THEN 'Dx Secundario / No puede determinarse clínicamente si la condición estaba o no presente en el episodio'
		WHEN f.Tipo LIKE 'S' AND F.poad LIKE 'N' THEN 'Dx Secundario No Presente en el Episodio'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'E' THEN 'Dx Secundario Exento de Informar POA'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'D' THEN 'Dx Secundario / Documentación insuficiente para determinar si la condición esté presente o no al momento del episodio'
		ELSE NULL
	END AS condition_status_source_value, 
	c.vocabulary_id 
	
FROM BBDD_EmilianoDelia.OMOP_CDM.VISIT_OCCURRENCE V

	JOIN BBDD_EmilianoDelia.OMOP_CDM.PERSON PER ON PER.person_id = V.person_id
	JOIN Hosma.DBO.DMedica D ON (V.visit_occurrence_id = D.IdEpisodio AND D.TIPOEPISODIO = 'I')
	JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
	JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
	LEFT JOIN bbdd_emilianodelia.OMOP_CDM.CONCEPT c on c.concept_code = cie10.codigocie10  

WHERE 
		V.visit_concept_id LIKE 9201 -- ONLY INCLUDE IP VISITS 
	AND V.visit_start_date is not null 
	AND V.visit_start_date >= '2016-01-01' 
	AND V.visit_start_date <= '2023-12-31' 
	AND cie10.TipoCIE10 LIKE 'D'    -- WE ONLY WANT DIOGNOSTICS FROM OUR INTENAL ICD10 CODING 
	AND C.vocabulary_id IN ('ICD10', 'ICD10CM')  -- VOCABULARY ID HAS TO BE ICD10
	AND C.DOMAIN_ID LIKE 'CONDITION' -- ONLY CONDITIONS FROM CONCEPT TABLE 

UNION ALL 

SELECT DISTINCT
	
	f.IdFichaDMedica10 as condition_occurrence_id, --EACH INSTANCE OF A CONDITION IS ALREADY SET WITH A UNIQUE ID INTERNALLY
	PER.person_id as person_id, 
	C.concept_id as ICD10_condition_concept_id, -- FROM THE CONCEPT TABLE 
	/* Most often data sources do not have the idea of a start date for a condition. 
		Rather, if a source only has one date associated with a condition record it is 
		acceptable to use that date for both the CONDITION_START_DATE and the CONDITION_END_DATE.*/
	CONVERT(date, V.visit_start_date) as condition_start_date, 
	CONVERT(varchar, CONVERT(date, V.visit_start_date)) + ' ' + '00:00:00.000' AS condition_start_datetime, 
	CONVERT(date, V.visit_start_date) as condition_end_date, 
	CONVERT(varchar, CONVERT(date, V.visit_start_date)) + ' ' + '00:00:00.000' AS condition_end_datetime, 
	32817 as condition_type_concept_id, -- indicates where the record comes from (in our case is always EHR)
	CASE 
		/*When the Dx is marked as primary this always means that the Dx was present in the episode */
		WHEN f.Tipo = 'P' THEN 32901 -- Vocab: Condition Status / Admission Diagnosis 
		/*When the Dx is secondary but is also present in the episode  */
		WHEN f.Tipo ='S' AND f.POAD = 'S' THEN 32907 -- Vocab: Condition Status / Secondary Admission Diagnosis
		/* Any other classifications of a secondary Dx belongs as a plain Secondary Dx*/
	ELSE 32908 -- Vocab: Condition Status / Secondary Diagnosis  as condition_status_concept_id, 
	END AS condition_status_concept_id, 
	'' AS stop_reason, 
	V.provider_id AS provider_id, 
	V.visit_occurrence_id AS visit_occurrence_id,
	'' as visit_detail_id, 
	cie10.CodigoCIE10 AS condition_source_value,
	c.concept_id AS condition_source_concept_id, 
	CASE
		WHEN f.Tipo LIKE 'P' AND F.POAD LIKE 'S'THEN 'Dx Primario Presente en el momento del Episodio'
		WHEN F.Tipo LIKE 'P' AND F.POAD LIKE 'D' THEN 'Dx Primario / Documentación insuficiente para determinar si la condición esté presente o no al momento del episodio'
		WHEN F.Tipo LIKE 'P' AND F.POAD LIKE 'E' THEN 'Dx Primario Exento de Informar POA'
		WHEN f.Tipo LIKE 'p' and F.POAD LIKE 'N' THEN 'Dx Primario No presente en el episodio'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'S' THEN 'Dx Secundario Presente en el Ingreso'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'I' THEN 'Dx Secundario / No puede determinarse clínicamente si la condición estaba o no presente en el episodio'
		WHEN f.Tipo LIKE 'S' AND F.poad LIKE 'N' THEN 'Dx Secundario No Presente en el Episodio'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'E' THEN 'Dx Secundario Exento de Informar POA'
		WHEN f.Tipo LIKE 'S' AND F.POAD LIKE 'D' THEN 'Dx Secundario / Documentación insuficiente para determinar si la condición esté presente o no al momento del episodio'
		ELSE NULL
	END AS condition_status_source_value, 
	c.vocabulary_id

FROM BBDD_EmilianoDelia.OMOP_CDM.VISIT_OCCURRENCE V

	JOIN BBDD_EmilianoDelia.OMOP_CDM.PERSON PER ON PER.person_id = V.person_id
 	JOIN Hosma.DBO.DMedica D ON (V.visit_occurrence_id = D.IdEpisodio AND D.TIPOEPISODIO = 'A')
	JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
	JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
	LEFT JOIN bbdd_emilianodelia.OMOP_CDM.CONCEPT c on c.concept_code = cie10.codigocie10 
  
WHERE 

		V.visit_concept_id LIKE 9202 -- ONLY INCLUDE OP VISITS 
	AND V.visit_start_date >=  '2016-01-01'  
	AND V.visit_start_date <= '2023-12-31'  
	AND cie10.TipoCIE10 LIKE 'D'   -- WE ONLY WANT DIOGNOSTICS FROM THE CIE10 VOCAB 
	AND C.vocabulary_id IN ('ICD10', 'ICD10CM')  -- VOCABULARY ID HAS TO BE ICD10
	AND C.DOMAIN_ID LIKE 'CONDITION' -- ONLY ICD10 CONDITIONS FROM CONCEPT TABLE 
)

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.condition_occurrence (
    condition_occurrence_id,                    
    person_id,            
    condition_concept_id,    
    condition_start_date , 
    condition_start_datetime, 
    condition_end_date , 
    condition_end_datetime , 
    condition_type_concept_id , 
    condition_status_concept_id , 
    stop_reason, 
    provider_id , 
    visit_occurrence_id, 
    visit_detail_id , 
    condition_source_value, 
    condition_source_concept_id , 
    condition_status_source_value)

SELECT
	condition_occurrence_id,                    
    person_id,            
    SUB.concept_id_2 AS condition_concept_id,    
    condition_start_date , 
    condition_start_datetime, 
    condition_end_date , 
    condition_end_datetime , 
    condition_type_concept_id , 
    condition_status_concept_id, 
    stop_reason, 
    provider_id , 
    visit_occurrence_id, 
    visit_detail_id,
    condition_source_value, 
    condition_source_concept_id , 
    condition_status_source_value 

FROM 
	(
	 SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY CONDITION_OCCURRENCE_ID ORDER BY vocabulary_id DESC) AS rn
	 FROM cte C
	 LEFT JOIN BBDD_EmilianoDelia.OMOP_CDM.CONCEPT_RELATIONSHIP CR ON C.ICD10_condition_concept_id = CR.concept_id_1 AND CR.relationship_id LIKE 'MAPS TO'
		) AS SUB
WHERE RN = 1 
ORDER BY condition_start_date, visit_occurrence_id asc 


