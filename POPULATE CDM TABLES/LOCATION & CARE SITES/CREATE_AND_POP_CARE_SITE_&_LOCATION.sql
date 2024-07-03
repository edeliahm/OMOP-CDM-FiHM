INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.LOCATION(
	location_id,
	address_1,
	address_2, 
	city, 
	state, 
	zip, 
	county, 
	location_source_value, 
	country_concept_id,
	country_source_value, 
	latitude, 
	longitude)

SELECT DISTINCT
	
	o.IdHospital as location_id, 
	direccion as address_1,
	'' as address_2, 
	poblacion as city, 
	provincia as state, 
	CP as zip, 
	p.nombre_com_autonoma as county, 
	o.Poblacion + ',' + ' ' + O.Provincia + ',' + ' ' + p.codigo_com_autonoma  as location_source_value, 
	4328760 as country_concept_id, -- STANDARD CONCEPT FOR SPAIN (DOMAIN: GROGRAPHY)(CLASS: LOCATION)
	'España' as country_source_value, 
	null as latitude, 
	null as longitude 

FROM hosma.dbo.Organizacion O 
join BBDD_EmilianoDelia.dbo.diccionario_provincias p on p.codigo_com_autonoma = o.ComunidadCMBD

order by state, city

/* ************************************************************************ */
/* ************************************************************************ */
/* LOCATION TABLE NEEDS TO BE POPULATED BEFORE CREATING THE CARE_SITE TABLE */
/* ************************************************************************ */
/* ************************************************************************ */

--IF OBJECT_ID('bbdd_emilianodelia.OMOP_CDM.CARE_SITE', 'U') IS NOT NULL
--BEGIN
--	DROP TABLE bbdd_emilianodelia.OMOP_CDM.CARE_SITE;
--END;

--CREATE TABLE BBDD_EmilianoDelia.OMOP_CDM.CARE_SITE (
--			care_site_id bigint PRIMARY KEY NONCLUSTERED,
--			care_site_name varchar(255) NULL,
--			place_of_service_concept_id integer NULL ,
--			location_id integer NULL,
--			care_site_source_value varchar(100) NULL,
--			place_of_service_source_value varchar(50) NULL );

INSERT INTO BBDD_EmilianoDelia.OMOP_CDM.CARE_SITE(
	care_site_id,
	care_site_name, 
	place_of_service_concept_id, 
	location_id, 
	care_site_source_value, 
	place_of_service_source_value)

SELECT DISTINCT
CASE 
	/* CARE_SITE_ID CONCATENATES THE TYPE OF CENTER AND ITS TRUE HOSPITAL_ID */
	WHEN O.NombreLargo LIKE 'Hospital de día%' THEN CAST(38004210 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
	ELSE CAST(38004515 AS VARCHAR(10)) + CAST(O.IdHospital AS VARCHAR(10))
END AS care_site_id, 
O.NombreLargo AS care_site_name, 
CASE
	WHEN O.NombreLargo LIKE 'Hospital de día%' THEN 38004210 -- CONCEPT_ID FOR OUTPATIENT HOSPITAL
	ELSE 38004515 -- CONCEPT_ID FOR HOSPITALS
END AS place_of_service_concept_id, 
L.location_id AS location_id, 
O.NombreCortoWeb AS care_site_source_value,
'' AS place_of_service_source_value

FROM BBDD_EMILIANODELIA.DBO.location L 
JOIN hosma.dbo.organizacion O ON O.IdHospital = L.location_id

--CHANGE BACK DATATYPES
DECLARE @care_site_id AS BIGINT
;

