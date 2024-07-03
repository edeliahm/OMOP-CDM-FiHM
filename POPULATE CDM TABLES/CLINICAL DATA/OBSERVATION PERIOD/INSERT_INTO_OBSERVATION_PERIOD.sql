TRUNCATE TABLE BBDD_EMILIANODELIA.OMOP_CDM.OBSERVATION_PERIOD;

USE Hosma;

WITH cte AS (

SELECT DISTINCT 
	'' as observation_period_id, 
	P.idpaciente as person_id, 
	i.FechaIngreso as observation_period_start_date, 
	i.FechaAlta as observation_period_end_date, 
	32817 as period_type_concept_id   -- domain: type concept / vocab: type concept / name: EHR 

FROM ingresos i 
JOIN Organizacion o ON O.IdHospital = i.idhospital
JOIN PACIENTES P ON P.IdPaciente = I.IdPaciente

WHERE 
	I.FechaIngreso >= '2016-01-01' AND 
	i.fechaingreso <= '2023-12-31' AND 
	I.FECHAALTA IS NOT NULL AND -- observation_end_date cannot be null
	P.FECHANAC IS NOT NULL

UNION ALL 

SELECT DISTINCT
	'' as observation_period_id, 
	p.idpaciente as person_id, 
	A.FechaIngreso as observation_period_start_date, 
	A.FechaIngreso as observation_period_end_date, 
	32817 as period_type_concept_id -- domain: type concept / vocab; type concept / name: EHR

FROM AMBULANTES A 
JOIN pacientes p ON p.idPaciente = A.IdPaciente
JOIN Organizacion o ON O.IdHospital = A.idhospital

WHERE 
	A.FechaIngreso >= '2016-01-01' AND
	a.fechaingreso <= '2023-12-31' AND
	P.FECHANAC IS NOT NULL AND 
	P.IdPaciente NOT LIKE 1 -- THIS RECORD HOLDS ERRORS 
)

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.observation_period ( 
	person_id,
	observation_period_start_date, 
	observation_period_end_date, 
	period_type_concept_id)

SELECT
	--'' as observation_period_id, -- field is auto-populated
	person_id,
	observation_period_start_date, 
	observation_period_end_date, 
	period_type_concept_id

FROM cte
