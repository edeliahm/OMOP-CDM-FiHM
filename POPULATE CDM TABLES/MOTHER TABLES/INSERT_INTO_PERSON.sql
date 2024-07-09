SET DATEFORMAT 'YMD';

TRUNCATE TABLE bbdd_emilianodelia.omop_cdm.person;

WITH CTE AS ( 

 SELECT DISTINCT

	P.IdPaciente AS person_id,
    CASE 
        WHEN p.sexo = 1 THEN 8507  -- DOMAIN: GENDER 
        WHEN p.sexo = 2 THEN 8532  -- DOMAIN: GENDER
        ELSE 0  -- THERE IS NO STD CONCEPT FOR NOT KNOWN GENDER
    END AS gender_concept_id,
    DATEPART(YEAR, p.fechanac) AS year_of_birth, 
    DATEPART(MONTH, p.fechanac) AS month_of_birth, 
    DATEPART(DAY, p.fechanac) AS day_of_birth,
    P.FECHANAC AS birth_datetime, 
    '' AS race_concept_id, 
    '' AS ethnicity_concept_id, 
	'' as location_id,
    '' AS provider_id,  
    '' AS care_site_id,
    '' AS person_source_value, 
    CASE 
        WHEN P.SEXO = 1 THEN 'Hombre' 
        WHEN p.SEXO = 2 THEN 'Mujer'
        WHEN p.SEXO = 3 THEN 'Indeterminado'
    END AS gender_source_value, 
    P.Sexo AS gender_source_concept_id, 
    '' AS race_source_value, 
    '' AS race_source_concept_id, 
    '' AS ethnicity_source_value, 
    '' AS ethnicity_source_concept_id

 FROM hosma.dbo.pacientes p
 
 WHERE 
		P.IDPACIENTE NOT LIKE 1 AND
		P.FechaNac IS NOT NULL
)

INSERT INTO bbdd_emilianodelia.omop_cdm.person(
	person_id,
	gender_concept_id,
	year_of_birth, 
	month_of_birth, 
	day_of_birth,
	birth_datetime, 
	race_concept_id, 
	ethnicity_concept_id, 
	location_id,  
	provider_id,  
	care_site_id, 
	person_source_value, 
	gender_source_value, 
	gender_source_concept_id, 
	race_source_value, 
	race_source_concept_id, 
	ethnicity_source_value, 
	ethnicity_source_concept_id)

SELECT DISTINCT
    person_id,
    gender_concept_id,
    year_of_birth, 
    month_of_birth, 
    day_of_birth,
    birth_datetime, 
    race_concept_id, 
    ethnicity_concept_id, 
    location_id,  
    provider_id,  
    care_site_id, 
    person_source_value, 
    gender_source_value, 
    gender_source_concept_id, 
    race_source_value, 
    race_source_concept_id, 
    ethnicity_source_value, 
    ethnicity_source_concept_id

FROM CTE 

