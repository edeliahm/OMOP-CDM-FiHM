USE [Hosma-Doctor];

WITH CTE AS (

SELECT top 50000

	LAB.codigoPruebaOBR + '___' +  LAB.codigoPrueba AS local_code,

	lab.id as measurement_id, 
	i.idpaciente as person_id, 

	'' as measurement_concept_id, -- se llena con el JOIN

	convert(date, lab.fechaMuestra) as measurement_date, 
	convert(datetime, lab.fechamuestra) as measurement_datetime, 
	'' as measurement_time, -- we don´t have this 
	32856 as measurement_type_concept_id, -- the provenance of the record == LAB

	case 
		when lab.resultado like '>%' then 4172704
		when lab.resultado like '<%' then 4171756
		when lab.resultado like '<=%' then 4171754
		when lab.resultado like '>=%' then 4171755
		when lab.resultado like '[1-9]%' then NULL -- DOCUMENTATION --> Leave it NULL if there’s an exact numeric value given
	else NULL
	end as operator_concept_id,

	/************************************************************/
	/* USING A FUNCTION TO EXTRACT NUMERICAL VALUES FROM COLUMN */
	/************************************************************/
	BBDD_EMILIANODELIA.dbo.getNumericValue(lab.resultado) as value_as_number, 
	/***********************************************************/
	/***********************************************************/
	CASE /* ALL OF THE FOLLOWING UNITS ARE MAPPED TO CONCEPTS FROM THE 'UNIT' DOMAIN AND 'UCUM' VOCABULARY */

		WHEN LAB.unidades = '%' THEN 8554 -- percent 
		WHEN LAB.unidades = 'µg/dL' THEN 8837 --microgram per deciliter
		WHEN LAB.unidades = 'µg/mL' then 8837 -- microgram per deciliter
		WHEN LAB.unidades = 'µmol/L' then 8749	--micromole per liter
		when LAB.unidades = 'µUI/mL' then 9093	--micro-international unit per milliliter

		when LAB.unidades = 'cel/µL' then 8784	--cells per microliter
		when LAB.unidades = 'celulas/mm3' then 8888	--cells per cubic millimeter

		when LAB.unidades = 'fL' then 8583 --femtoliter

		when LAB.unidades = 'g/24h' then 8807 --gram per 24 hours
		when LAB.unidades = 'g/dL' then 8713 -- gram per deciliter

		when LAB.unidades = 'IC' then NULL -- indice de corte -- los valores con esta unidad suelen ser valores categóricos 

		when LAB.unidades = 'mg/24h' then 8909 -- milligram per 24 hours
		when LAB.unidades = 'mg/dL' then 8840	--milligram per deciliter
		when LAB.unidades = 'mg/Kg' then 9562	--milligram per kilogram
		when LAB.unidades = 'mg/L' then 8751	--milligram per liter
		when LAB.unidades = 'mIU/mL' or unidades like 'mUI/mL' then 9550 	-- milli-international unit per milliliter

		when lab.unidades = 'mL' then 8587 --	milliliter
		when LAB.unidades = 'mL/min' then 8795	--milliliter per minute
		when LAB.unidades = 'mL/min/1,73 m2' then 720870 --milliliter per minute per 1.73 square meter

		when lab.unidades = 'mm' then 8588	--millimeter
		when LAB.unidades = 'mm/h' then 8752	--millimeter per hour
		when LAB.unidades = 'mmHg' then 8876	--millimeter mercury column
		when LAB.unidades = 'mmol/L' then 8753	--millimole per litter

		when LAB.unidades = 'ng/dL' then 8840	--milligram per deciliter
		when LAB.unidades = 'ng/L' then 8751	--milligram per liter
		when LAB.unidades = 'ng/L' then 8725 -- nanogram per liter
		when LAB.unidades = 'ng/mL' then 8842 -- nanogram per milliliter

		when lab.unidades = 'ng/mL/h' then 9020 --	nanogram per milliliter and hour

		when lab.unidades = 'nmol/L' then 8736 --nanomole per liter
		when lab.unidades = 'pmol/L' then 8729 --picomole per liter

		when LAB.unidades = 'pg' then 8564 -- picogram
		when LAB.unidades = 'pg/mL' then 8845 -- picogram per milliliter
		when LAB.unidades = 's' then 8555 -- second

		when LAB.unidades = 'U/L' then 8645 -- unit per liter
		when lab.unidades = 'UI/L' then 8923 -- international unit per liter
		when LAB.unidades = 'U/mL' then 8763 --unit per milliliter
		when LAB.unidades = 'UI/mL' then 8985 --international unit per milliliter
		when lab.unidades = 'kUI/L' then 8923 --	international unit per liter (es lo mismo que UI/L)

		/** IN BOTH OF THESE CASES THE RESULTS WITH UNITS THAT HAVE A '?' HAVE THE SAME RANGE OF VALUES AS **/
		/** THE NORMALLY WRITTEN UNITS, THIS SAID, EACH PAIR OF UNITS BELONG TO THE SAME UNIT FORMAT **/
		when LAB.unidades = 'x10e3/µL' or lab.unidades like 'x10e3/?L' then 8848	--thousand per microliter
		when LAB.unidades = 'x10e6/µL' or lab.unidades like 'x10e6/?L' then 8815	--million per microliter
	else NULL
	end as unit_concept_id, 

	CASE 
		WHEN LAB.valoresReferencia LIKE '%[a-zA-Z]%' OR LAB.valoresReferencia LIKE '(-%' THEN NULL 
		WHEN LAB.valoresReferencia LIKE '(%' AND LAB.valoresReferencia LIKE '%)' THEN 
			RTRIM(LTRIM(SUBSTRING(lab.valoresReferencia, CHARINDEX('(', lab.valoresReferencia) + 1, CHARINDEX('-', lab.valoresReferencia) - CHARINDEX('(', lab.valoresReferencia) - 1)))
		WHEN LAB.valoresReferencia LIKE '>%' THEN 
			SUBSTRING(lab.valoresReferencia, PATINDEX('%[0-9]%', lab.valoresReferencia), LEN(lab.valoresReferencia))
		--WHEN LAB.valoresReferencia LIKE '%-%' THEN 
		--	SUBSTRING(lab.valoresReferencia, 1, CHARINDEX('-', lab.valoresReferencia) - 1)
		ELSE NULL 
	END AS range_low, 

	CASE 
		WHEN LAB.valoresReferencia LIKE '%[a-zA-Z]%' OR LAB.valoresReferencia LIKE '(-%'THEN NULL 
		WHEN LAB.valoresReferencia LIKE '(%' AND LAB.valoresReferencia LIKE '%)' THEN 
			RTRIM(LTRIM(SUBSTRING(lab.valoresReferencia, CHARINDEX('-', lab.valoresReferencia) + 1, CHARINDEX(')', lab.valoresReferencia) - CHARINDEX('-', lab.valoresReferencia) - 1)))
		WHEN LAB.valoresReferencia LIKE '<%' THEN 
			SUBSTRING(lab.valoresReferencia, PATINDEX('%[0-9]%', lab.valoresReferencia), LEN(lab.valoresReferencia))
		WHEN LAB.valoresReferencia LIKE '%-%' THEN 
			SUBSTRING(lab.valoresReferencia, CHARINDEX('-', lab.valoresReferencia) + 1, LEN(lab.valoresReferencia))
		ELSE NULL 
	END AS range_high,

	i.IdDoctor AS provider_id, 
	i.IdIngreso as visit_occurrence_id, 
	'' AS visit_detail, 

	/* IF THE DATE OF LAB TEST IS BETWEEN THE ENTERING AN EXIT FROM THE ICU THEN WE NEED TO LINK THE LAB TEST TO THAT PARTICULAR ICU VISIT */

	--CASE WHEN LAB.FECHAMUESTRA >= UCI.fechaEntrada AND LAB.FECHAMUESTRA <= UCI.fechaSalida THEN UCI.idEstancia ELSE NULL END AS visit_detail,

	/*******/

	lab.codigoPruebaOBR + /*'___' + lab.codigoprueba +*/ ' - ' + lab.nombrePrueba as measurement_source_value, 
	null as measurement_source_concept_id, 
	lab.unidades as unit_source_value, 
	null as unit_source_concept_id, 
	lab.resultado as value_source_value, 
	'' as measurement_event_id, 
	'' as meas_event_field_concept_id

	--CASE 
	--	WHEN I.HoraIngreso = '' THEN CONVERT(VARCHAR, CONVERT(DATE, i.FechaIngreso)) + ' ' + '00:00:00.000'
	--	ELSE CONVERT(VARCHAR, CONVERT(DATE, i.FechaIngreso)) + ' ' + i.HoraIngreso + ':00.000'
	--END as fecha_ingreso_planta, 

	--CASE 
	--	WHEN I.HoraAlta = '' THEN CONVERT(varchar, CONVERT(DATE, i.FechaAlta)) + ' ' + '00:00:00.000'
	--	ELSE CONVERT(VARCHAR, CONVERT(DATE, i.FechaAlta)) + ' ' + i.HoraAlta + ':00.000' 
	--END as fecha_alta_planta,

	--UCI.fechaEntrada, 
	--UCI.fechaSalida

FROM LaboratorioResultados_lab LAB 
JOIN HOSMA.DBO.INGRESOS I ON I.IDPACIENTE = LAB.NIP
LEFT JOIN HOSMA.DBO.UCI_Estancias UCI ON UCI.idEpisodio = I.IdIngreso AND UCI.tipo = 'I'

WHERE
	LAB.NIP NOT LIKE '%[^0-9]%' AND    
	LAB.NIP LIKE I.IdPaciente AND 
	LAB.fechaMuestra >= I.FechaIngreso AND lab.fechamuestra <= I.FechaAlta AND 

	/** HOSPITAL FILTERING FOR FASTER TESTING */
	I.IdHospital LIKE 1 AND -- CÓDIGO PARA HM MADRID

	/* DATE FILTERING TO FOR FAST TESTING */
	DATEPART(YEAR, I.FechaIngreso) like '2022' AND 
	DATEPART(MONTH, I.FechaIngreso) BETWEEN '01' AND '06'
)

--SELECT * FROM CTE ORDER BY LOCAL_CODE ASC

--SELECT * FROM BBDD_EmilianoDelia.DBO.hmhos_lab_mappings ORDER BY LOCAL_CODE ASC


SELECT

    lab.measurement_id, 
	lab.person_id, 

	c.concept_id as measurement_concept_id, -- standard concept 
	c.concept_name, 
	c.standard_concept, 

	lab.measurement_date, 
	lab.measurement_datetime, 
	lab.measurement_time, 
	lab.measurement_type_concept_id, 

	lab.operator_concept_id,

	/* WHEN A ROW DOES NOT CONTAIN NUMERICAL VALUES SKIP IT */
	CASE WHEN lab.value_as_number LIKE '%[0-9]%' THEN LAB.value_as_number ELSE '' end as value_as_number, 

	lab.unit_concept_id, 
	lab.range_low, 
	lab.range_high,
	lab.provider_id, 
	lab.visit_occurrence_id, 
	lab.visit_detail,
	lab.measurement_source_value, 
	lab.measurement_source_concept_id, 
	lab.unit_source_value, 
	lab.unit_source_concept_id, 
	lab.value_source_value, 
	lab.measurement_event_id, 
	lab.meas_event_field_concept_id

FROM  BBDD_EmilianoDelia.DBO.hmhos_lab_mappings MAP

/** WE ONLY WANT TO KEEP LAB TESTS PRESENT IN THE MAPPING PROVIDED BY TrinetX **/
/** THIS JOIN COMPLETES THIS TASK */
JOIN CTE LAB ON LAB.local_code = MAP.local_code
JOIN BBDD_EmilianoDelia.dbo.concept c on c.concept_code = map.mapped_to_code

where 
	c.vocabulary_id like 'LOINC' and 
	c.domain_id like 'measurement' and 
	c.concept_class_id like 'lab test' and 
	c.standard_concept like 's' 
	
ORDER BY visit_occurrence_id, person_id, LAB.measurement_date ASC
