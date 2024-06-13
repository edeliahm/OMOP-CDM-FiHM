/*
IF OBJECT_ID('bbdd_emilianodelia.dbo.PERSON', 'U') IS NOT NULL
BEGIN
	DROP TABLE bbdd_emilianodelia.dbo.PERSON;
END;
--HINT DISTRIBUTE ON KEY (person_id)
CREATE TABLE BBDD_EmilianoDelia.dbo.PERSON (
			person_id integer PRIMARY KEY NONCLUSTERED, -- SETTING PK AND INDEX AT ONCE 
			gender_concept_id integer NOT NULL REFERENCES BBDD_EMILIANODELIA.DBO.CONCEPT(CONCEPT_ID),
			year_of_birth integer NOT NULL,
			month_of_birth integer NULL,
			day_of_birth integer NULL,
			birth_datetime datetime NULL,
			race_concept_id integer NOT NULL,
			ethnicity_concept_id integer NOT NULL,
			location_id integer NULL,
			provider_id integer NULL,
			care_site_id bigint NULL,
			person_source_value varchar(50) NULL,
			gender_source_value varchar(50) NULL,
			gender_source_concept_id integer NULL,
			race_source_value varchar(50) NULL,
			race_source_concept_id integer NULL,
			ethnicity_source_value varchar(50) NULL,
			ethnicity_source_concept_id integer NULL )
*/
-- INSERT INTO 

SET DATEFORMAT 'YMD';

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.PERSON', 'U') IS NOT NULL
BEGIN
    TRUNCATE TABLE BBDD_EMILIANODELIA.DBO.PERSON;
END;

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
    '' AS ethnicity_concept_id,  -- FK Table: Concept / FK Domain: Ethnicity 
    '' AS location_id,  -- FK table: location
    '' AS provider_id,  -- FK table: Provider 
    '' AS care_site_id,  -- FK table: Care Site
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

 FROM HOSMA.DBO.PACIENTES P
 
 WHERE 
		P.IDPACIENTE NOT LIKE 1 AND
		P.FechaNac IS NOT NULL
)

/* INSERT INTO STATEMENT */

INSERT INTO BBDD_EmilianoDelia.dbo.person (
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

/* SELECT ONLY ONE RECORD PER PATIENT */

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

