SET DATEFORMAT 'YMD'

TRUNCATE TABLE bbdd_emiliano.omop_cdm.observation_period;

USE Hosma;

WITH cte AS (

SELECT DISTINCT 
	'' as observation_period_id, 
	P.idpaciente as person_id, 
	convert(date, i.FechaIngreso) as observation_period_start_date, 
	convert(date, i.FechaAlta) as observation_period_end_date, 
	32817 as period_type_concept_id   -- domain: type concept / vocab: type concept / name: EHR 

FROM ingresos i 
	JOIN Organizacion o ON O.IdHospital = i.idhospital
	JOIN PACIENTES P ON P.IdPaciente = I.IdPaciente

WHERE 
		CONVERT(DATE, I.FechaIngreso) >= '2016-01-01' 
	AND CONVERT(DATE, i.FechaAlta) <= GETDATE()  
	AND I.fechaingreso IS NOT NULL  -- observation_end_date cannot be null
	AND P.FECHANAC IS NOT NULL

UNION ALL 

SELECT DISTINCT
	'' as observation_period_id, 
	p.idpaciente as person_id, 
	convert(date, A.FechaIngreso) as observation_period_start_date, 
	convert(date, A.FechaIngreso) as observation_period_end_date, 
	32817 as period_type_concept_id -- domain: type concept / vocab; type concept / name: EHR

FROM ambulantes a
	JOIN pacientes p ON p.idPaciente = a.IdPaciente
	JOIN organizacion o ON o.IdHospital = a.idhospital
   
WHERE 
		CONVERT(DATE, A.fechaingreso) >= '2016-01-01'
	AND convert(date, A.fechaingreso) <= GETDATE() 
	AND fechanac IS NOT NULL  
	AND P.idpaciente NOT LIKE 1 -- THIS RECORD HOLDS ERRORS 
)


INSERT INTO bbdd_emilianodelia.omop_cdm.observation_period ( 
	person_id,
	observation_period_start_date, 
	observation_period_end_date, 
	period_type_concept_id)


SELECT DISTINCT
	--'' as observation_period_id, -- field is auto-populated
	person_id,
	observation_period_start_date, 
	observation_period_end_date, 
	period_type_concept_id

FROM cte