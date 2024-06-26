SET DATEFORMAT YMD;

TRUNCATE TABLE BBDD_EmilianoDelia.OMOP_CDM.DRUG_EXPOSURE;

USE [Hosma-Doctor];

WITH CTE AS (
    SELECT
        LEFT(e1.code_nac, LEN(e1.code_nac) - 1) AS local_code, 
        '' AS drug_exposure_id, 
        PER.person_id AS person_id, 
        '' AS drug_concept_id,
		TRY_CONVERT(DATE, LEFT(T.FechaInicio, 8), 112) AS drug_exposure_start_date,
		TRY_CONVERT(DATETIME, LEFT(T.FechaInicio, 8), 112) AS drug_exposure_start_datetime,
		CASE 
			WHEN T.FechaFin IS NULL OR T.FechaFin LIKE 0 THEN V.visit_end_date
			ELSE TRY_CONVERT(DATE, LEFT(T.FechaFin, 8), 112)
		END AS drug_exposure_end_date, 
		CASE 
			WHEN T.FechaFin IS NULL OR T.FECHAFIN LIKE 0 THEN V.visit_end_datetime
			ELSE TRY_CONVERT(DATETIME, LEFT(T.FechaFin, 8), 112)
		END AS drug_exposure_end_datetime, 
        CASE 
			WHEN T.FechaFin IS NULL OR T.FechaFin LIKE 0 THEN V.visit_end_date
			ELSE TRY_CONVERT(DATE, LEFT(T.FechaFin, 8), 112)
		END AS verbatim_end_date, 
        32818 AS drug_type_concept_id, 
        '' AS stop_reason, 
        '' AS refills, 
        '' AS quantity, 
        '' AS days_supply, 
        '' AS sig, 
        '' AS route_concept_id, 
        '' AS lot_number, 
        V.provider_id AS provider_id, 
        V.visit_occurrence_id AS visit_occurrence_id, 
        '' AS visit_detail_id, 
        LEFT(e1.code_nac, LEN(e1.code_nac) - 1) AS drug_source_value, 
        '' AS drug_source_concept_id, 
        '' AS route_source_value, 
        '' AS dose_unit_source_value

    FROM BBDD_EMILIANODELIA.OMOP_CDM.VISIT_OCCURRENCE V

	JOIN [Hosma-Doctor].dbo.TratamientoFarm T ON T.IdEpisodio = V.visit_occurrence_id AND (T.Tipo LIKE 'I')
	JOIN BBDD_EmilianoDelia.OMOP_CDM.PERSON PER ON PER.person_id = V.person_id 
	JOIN [Hosma].dbo.eo_comercial_drugs E1 ON (T.IdFarmacoEO = E1.Comercial_drug_id)

	--JOIN [Hosma].dbo.ingresos i ON (T.IdEpisodio = i.IdIngreso AND T.Tipo = 'I')

    WHERE 
		V.visit_concept_id LIKE 9201 AND --ONLY JOIN IP VISIT 
        V.visit_start_date >= '2016-01-01' AND -- LA FECHA MAS ANTIGUA DE CIE10 EMPIEZA EN EL 2015
		V.visit_start_date <= '2023-12-31' AND 
        T.validado = 1 

    UNION ALL 

    SELECT
        LEFT(e1.code_nac, LEN(e1.code_nac) - 1) AS local_code, 
        '' AS drug_exposure_id, 
        PER.person_id AS person_id, 
        '' AS drug_concept_id,
        TRY_CONVERT(DATE, LEFT(T.FechaInicio, 8), 112) AS drug_exposure_start_date,
		TRY_CONVERT(DATETIME, LEFT(T.FechaInicio, 8), 112) AS drug_exposure_start_datetime,
		CASE 
			WHEN T.FechaFin IS NULL OR T.FechaFin LIKE 0 THEN V.visit_end_date
			ELSE TRY_CONVERT(DATE, LEFT(T.FechaFin, 8), 112)
		END AS drug_exposure_end_date, 
		CASE 
			WHEN T.FechaFin IS NULL OR T.FECHAFIN LIKE 0 THEN V.visit_end_datetime
			ELSE TRY_CONVERT(DATETIME, LEFT(T.FechaFin, 8), 112)
		END AS drug_exposure_end_datetime, 
        CASE 
			WHEN T.FechaFin IS NULL OR T.FechaFin LIKE 0 THEN V.visit_end_date
			ELSE TRY_CONVERT(DATE, LEFT(T.FechaFin, 8), 112)
		END AS verbatim_end_date, 
        32818 AS drug_type_concept_id, 
        '' AS stop_reason, 
        '' AS refills, 
        '' AS quantity, 
        '' AS days_supply, 
        '' AS sig, 
        '' AS route_concept_id, 
        '' AS lot_number, 
        V.provider_id AS provider_id, 
        V.visit_occurrence_id AS visit_occurrence_id, 
        '' AS visit_detail_id, 
        LEFT(e1.code_nac, LEN(e1.code_nac) - 1) AS drug_source_value, 
        '' AS drug_source_concept_id, 
        '' AS route_source_value, 
        '' AS dose_unit_source_value

	FROM BBDD_EMILIANODELIA.OMOP_CDM.VISIT_OCCURRENCE V

    JOIN [Hosma-Doctor].dbo.TratamientoFarm T ON T.IdEpisodio = V.visit_occurrence_id AND (T.Tipo LIKE 'A')
	JOIN BBDD_EmilianoDelia.OMOP_CDM.PERSON PER ON PER.person_id = V.person_id 
    JOIN [Hosma].dbo.eo_comercial_drugs E1 ON (T.IdFarmacoEO = E1.Comercial_drug_id)

	--JOIN [Hosma].dbo.AMBULANTES AM ON (T.IdEpisodio = AM.IDAMBULANTE AND T.Tipo = 'A')

    WHERE 
		V.visit_concept_id LIKE 9201 AND --ONLY JOIN OP VISIT 
        V.visit_start_date >= '2016-01-01' AND -- LA FECHA MAS ANTIGUA DE CIE10 EMPIEZA EN EL 2015
		V.visit_start_date <= '2023-12-31' AND 
        T.validado = 1 
)

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.DRUG_EXPOSURE (
    person_id, 
    drug_concept_id, 
    drug_exposure_start_date, 
    drug_exposure_start_datetime, 
    drug_exposure_end_date, 
    drug_exposure_end_datetime, 
    verbatim_end_date, 
    drug_type_concept_id, 
    stop_reason, 
    refills, 
    quantity, 
    days_supply, 
    sig, 
    route_concept_id, 
    lot_number, 
    provider_id, 
    visit_occurrence_id, 
    visit_detail_id, 
    drug_source_value, 
    drug_source_concept_id, 
    route_source_value, 
    dose_unit_source_value
)
SELECT DISTINCT
    person_id, 
    con_med.concept_id AS drug_concept_id, 
    drug_exposure_start_date, 
    drug_exposure_start_datetime, 
    drug_exposure_end_date, 
    drug_exposure_end_datetime, 
    verbatim_end_date, 
    drug_type_concept_id, 
    stop_reason, 
    refills, 
    quantity, 
    days_supply, 
    sig, 
    route_concept_id, 
    lot_number, 
    provider_id, 
    visit_occurrence_id, 
    visit_detail_id, 
    drug_source_value, 
    con_med.concept_id AS drug_source_concept_id, 
    route.mapped_to_code AS route_source_value, 
    LTRIM(SUBSTRING(strength.mapped_to_code, PATINDEX('%[^0-9.]%', strength.mapped_to_code + ' '), LEN(strength.mapped_to_code))) AS dose_unit_source_value
FROM CTE TEMP
LEFT JOIN BBDD_EmilianoDelia.OMOP_CDM.hmhos_med_mappings med_code ON med_code.local_code = TEMP.local_code AND med_code.vocabulary IN ('RxNorm', 'RxDrug')
LEFT JOIN BBDD_EmilianoDelia.OMOP_CDM.CONCEPT con_med ON con_med.concept_code = med_code.mapped_to_code AND con_med.domain_id LIKE 'Drug'
LEFT JOIN BBDD_EmilianoDelia.OMOP_CDM.hmhos_med_mappings strength ON strength.local_code = TEMP.local_code AND strength.vocabulary LIKE 'Strength' 
LEFT JOIN BBDD_EmilianoDelia.OMOP_CDM.hmhos_med_mappings route ON route.local_code = TEMP.local_code AND route.vocabulary LIKE 'Route';

-- Ensuring that the declared variables match the types used in the insert
DECLARE @drug_exposure_start_date AS DATE;
DECLARE @drug_exposure_start_datetime AS DATETIME;
DECLARE @drug_exposure_end_date AS DATE;
DECLARE @drug_exposure_end_datetime AS DATETIME;
