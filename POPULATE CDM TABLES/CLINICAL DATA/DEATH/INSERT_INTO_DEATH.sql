
TRUNCATE TABLE BBDD_EMILIANODELIA.OMOP_CDM.DEATH

SET DATEFORMAT 'YMD'

TRUNCATE TABLE BBDD_EMILIANODELIA.OMOP_CDM.DEATH

/* SINCE WE ARE ONLY DEALINH WITH INGRESOS & AMBULANTES THERE IS NO NEED TO
LOCATE DEATH RECORDS THAT COME FROM URGENCIAS */

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.DEATH(
	person_id, 
	death_date, 
	death_datetime, 
	death_type_concept_id, 
	cause_concept_id, 
	cause_source_value,
	cause_source_concept_id) 

SELECT

	per.person_id, 
	convert(date, i.Fechaalta) as death_date, 
	NULL as death_datetime, -- we don´t record the time of death of patients, documentation says if not available then leave null 
	32817 as death_type_concept_id, --provenance of the death record, i.e., where it came from
	'' as cause_concept_id, 
	'' as cause_source_value, 
	'' as cause_source_concept_id

FROM BBDD_EmilianoDelia.OMOP_CDM.person per
join hosma.dbo.ingresos i on i.IdPaciente = per.person_id
JOIN [Hosma-Doctor].DBO.parametros pp on pp.CodParametro = i.MotivoAlta and GrupoParametro = 'MTA' 

WHERE 
	datepart(year, i.FechaIngreso) >= '2016' and 
	datepart(year, i.FechaIngreso) >= '2023' and -- range of dates just for testing 
	pp.ParametroDescr like 'fallecimiento' -- only death patients at the moment of the inpatient visit 