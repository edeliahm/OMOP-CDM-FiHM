TRUNCATE TABLE bbdd_emilianodelia.omop_cdm.visit_occurrence;

SET DATEFORMAT YMD;

USE Hosma;

WITH CTE AS (

	SELECT DISTINCT
		am.IdAmbulante AS visit_occurrence_id, 
		am.IdPaciente AS person_id, 
		9202 AS visit_concept_id, -- standard concept for Outpatient Visit from the "visit" Domain
		TRY_CONVERT(DATE, AMS.fechaingreso) AS visit_start_date, 
		am.fechaingreso as visit_start_datetime, 
		TRY_CONVERT(DATE, AMS.FechaIngreso) AS visit_end_date, 
		am.FECHAINGRESO AS visit_end_datetime, 
		32817 AS visit_type_concept_id, --indicates where the record comes from (EHR in this case)
		am.IdDoctor AS provider_id,
		CASE 
			WHEN O.NombreLargo LIKE 'Hospital de día%' THEN CAST(38004210 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
			ELSE CAST(38004515 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
		END AS care_site_id, 
		'Ambulante' AS visit_source_value, -- This field houses the verbatim value from the source data representing the kind of visit that took place (inpatient, outpatient, emergency, etc.)
		'' AS visit_source_concept_id, -- visit source value is not coded using an OMOP supported language so it stays blank
		0 AS admitted_from_concept_id, 
		'Domicilio' AS admitted_from_source_value, -- valor que representa tipos de ambulante
		map1.target_concept_id AS discharged_to_concept_id, 
		map1.SOURCE_CODE_DESCRIPTION AS discharged_to_source_value,
		'' AS preceding_visit_occurrence_id

	FROM [hosma-doctor].dbo.ambulantes ams
		JOIN pacientes p ON p.IdPaciente = ams.IdPaciente
		JOIN organizacion o ON o.IdHospital = AMS.IdHospital
		LEFT JOIN ambulantes am ON am.IdAmbulante = ams.IdAmbulante
		LEFT JOIN parametros pp1 ON pp1.CodParametro = am.MotivoAlta AND pp1.GrupoParametro = 'MAM'
		LEFT JOIN BBDD_EmilianoDelia.omop_cdm.source_to_concept_map map1 ON map1.source_code = am.MotivoAlta AND map1.source_vocabulary_id LIKE 'TIPOS_DE_ALTA_HM'

	WHERE 
			am.Anulado = 0  
		AND TRY_CONVERT(DATE, ams.fechaingreso) >= '2016-01-01' 
		AND TRY_CONVERT(DATE, ams.fechaingreso) <= GETDATE()
		AND P.FECHANAC IS NOT NULL

	UNION ALL 

	SELECT DISTINCT

		i.IdIngreso AS visit_occurrence_id, -- unique identifier for the occurrence 
		i.IdPaciente AS person_id, -- unique identifier for the patient 
		CASE /* CODES COMES FROM THE DOMAIN VISIT */
			WHEN MAP1.source_code LIKE 'U' THEN 262 --Emergency room and Inpatient Visit
			ELSE 9201 -- Inpatient visit 
		END AS visit_concept_id, 
		TRY_CONVERT(DATE, i.fechaingreso) AS visit_start_date, 
		CASE 
			WHEN I.HoraIngreso = '' THEN I.FECHAINGRESO 
			--WHEN I.HoraIngreso = '' THEN TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, i.FechaIngreso)) + ' ' + '00:00:00.000'
			ELSE TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, i.FechaIngreso)) + ' ' + i.HoraIngreso + ':00.000'
		END AS visit_start_datetime, 
		TRY_CONVERT(DATE, i.fechaalta) AS visit_end_date, 
		CASE 
			WHEN I.HoraAlta = '' THEN TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, i.FechaAlta)) + ' ' + '00:00:00.000'
			ELSE TRY_CONVERT(VARCHAR, TRY_CONVERT(DATE, i.FechaAlta)) + ' ' + i.HoraAlta + ':00.000' 
		END AS visit_end_datetime,
		32817 AS visit_type_concept_id, --indicates where the record comes from (EHR in this case)
		I.IdDoctor AS provider_id,
		CASE 
			WHEN O.NombreLargo LIKE 'Hospital de día%' THEN CAST(38004210 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
			ELSE CAST(38004515 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
		END AS care_site_id, 
		'Ingreso' AS visit_source_value, -- Verbatim value from the source data representing the kind of visit that took place
		'' AS visit_source_concept_id, -- visit source value is not coded using an OMOP supported language so it stays blank 
		map1.target_concept_id AS admitted_from_concept_id,
		map1.source_code_description AS admitted_from_source_value, 
		map.target_concept_id AS discharged_to_concept_id, 
		map.source_code_description AS discharged_to_source_value, 
		'' AS preceding_visit_occurrence_id

	FROM Ingresos I
		JOIN pacientes p ON P.IdPaciente = I.IdPaciente
		JOIN organizacion o ON o.IdHospital = i.IdHospital
		LEFT JOIN parametros pp ON pp.CodParametro = i.MotivoAlta AND pp.GrupoParametro = 'MTA'
		LEFT JOIN BBDD_EmilianoDelia.omop_cdm.source_to_concept_map map ON map.source_code = I.MotivoIngreso AND map.source_vocabulary_id LIKE 'TIPOS_DE_ALTA_HM'
		LEFT JOIN BBDD_EmilianoDelia.omop_cdm.source_to_concept_map map1 ON map1.source_code = I.TipoIngreso AND map1.source_vocabulary_id LIKE 'TIPOS_DE_INGRESO_HM'

	WHERE 
			I.FechaAlta IS NOT NULL  
		AND I.ANULADO = 0  
		AND TRY_CONVERT(DATE, I.fechaingreso) >= '2016-01-01'  
		AND TRY_CONVERT(DATE, I.fechaalta) <= GETDATE()  
		AND P.FechaNac IS NOT NULL -- PATIENTS THAT HAVE NO DATE OF BIRTH MUST BE DROPPED!
)

INSERT INTO BBDD_EmilianoDelia.omop_cdm.visit_occurrence (
    visit_occurrence_id, 
    person_id,
    visit_concept_id, 
    visit_start_date, 
    visit_start_datetime,
    visit_end_date, 
    visit_end_datetime,
    visit_type_concept_id, 
    provider_id, 
    care_site_id, 
    visit_source_value, 
    visit_source_concept_id, 
    admitted_from_concept_id, 
    admitted_from_source_value, 
    discharged_to_concept_id, 
    discharged_to_source_value,
    preceding_visit_occurrence_id)

SELECT
    visit_occurrence_id,
    person_id,
    visit_concept_id,
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime, 
    visit_type_concept_id,
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    discharged_to_concept_id,
    discharged_to_source_value,
    preceding_visit_occurrence_id

FROM
(
    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY c.visit_occurrence_id ORDER BY c.visit_occurrence_id DESC) AS rn
    FROM CTE C
) AS SUB
WHERE RN = 1 and visit_end_date is not null;

/* Ensuring this datatype is applied */
DECLARE @care_site_id AS BIGINT
declare @visit_start_date as DATE 
declare @visit_start_datetime as DATETIME 
declare @visit_end_date as DATE
declare @visit_end_datetime as DATETIME;