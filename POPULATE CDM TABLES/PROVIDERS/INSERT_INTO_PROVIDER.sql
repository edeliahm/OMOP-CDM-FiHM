
SET DATEFORMAT 'YMD'

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.PROVIDER', 'U') IS NOT NULL
BEGIN
	TRUNCATE TABLE BBDD_EMILIANODELIA.DBO.PROVIDER
END;

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.PROVIDER(provider_id, 
											provider_name, 
											npi, 
											dea, 
											specialty_concept_id, 
											care_site_id, 
											year_of_birth, 
											gender_concept_id, 
											provider_source_value,
											specialty_source_value, 
											specialty_source_concept_id, 
											gender_source_value, 
											gender_source_concept_id)

SELECT DISTINCT
	d.iddoctor as provider_id, 
	'' AS provider_name, 
	'' AS npi, 
	'' as dea, 
	map.target_concept_id AS specialty_concept_id, 
	'' as care_site_id, 
	'' AS year_or_birth, 
	'' as gender_concept_id, 
	D.IdDoctor AS provider_source_value, 
	map.source_code_description as specialty_source_value, 
	0 AS specialty_source_concept_id,
	'' AS gender_source_value, 
	'' AS gender_source_concept_id

FROM HOSMA.DBO.Doctores d
	left join [hosma-doctor].dbo.DoctoresEquipo e on e.IdDoctor = d.IdDoctor
	left join [hosma-doctor].dbo.EquiposDoctores ee on ee.IdEquipo = e.IdEquipo

	left join BBDD_EmilianoDelia.OMOP_CDM.SOURCE_TO_CONCEPT_MAP map on map.source_code = d.Departamento and map.source_vocabulary_id like 'ESPECIALIADES_MEDICAS_HM'

ORDER BY D.IdDoctor








