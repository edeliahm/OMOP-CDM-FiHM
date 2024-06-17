SET DATEFORMAT 'YMD'

TRUNCATE TABLE BBDD_EMILIANODELIA.DBO.DEATH

INSERT INTO BBDD_EmilianoDelia.dbo.death(person_id, 
										 death_date, 
										 death_datetime, 
										 death_type_concept_id, 
										 cause_concept_id, 
										 cause_source_value,
										 cause_source_concept_id
										 ) 

SELECT

	i.IdPaciente as person_id, 
	convert(date, i.Fechaalta) as death_date, 
	NULL as death_datetime, -- we don´t record the time of death of patients, documentation says if not available then leave null 
	32817 as death_type_concept_id, --provenance of the death record, i.e., where it came from
	'' as cause_concept_id, 
	'' as cause_source_value, 
	'' as cause_source_concept_id

FROM hosma.dbo.ingresos i 
JOIN [Hosma-Doctor].DBO.parametros pp on pp.CodParametro = i.MotivoAlta and GrupoParametro = 'mta' 
JOIN [Hosma-Doctor].DBO.Organizacion o on o.IdHospital = i.IdHospital

WHERE 
	datepart(year, i.FechaIngreso) between '2019' and '2023' and -- range of dates just for testing 
	o.NombreCorto like 'madrid' and  -- only madrid just for testing 
	pp.ParametroDescr like 'fallecimiento' -- only death patients at the moment of the inpatient visit 