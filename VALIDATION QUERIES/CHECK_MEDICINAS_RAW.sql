USE [Hosma-Doctor];

with cte as (

SELECT
	i.IdPaciente as id_paciente, 
	i.idingreso as id_ingreso, 
	t.idtratamientofarm as id_tratamiento, 
	LEFT(e1.code_nac, LEN(e1.code_nac) - 1) as local_code,
	e1.name as nom_comercial, 
	PRINCIPIOACTIVO as principio_activo 

FROM [Hosma-Doctor].dbo.TratamientoFarm T
 
	JOIN [Hosma].dbo.ingresos i ON (T.IdEpisodio = i.IdIngreso AND T.Tipo='I')
	JOIN [Hosma].dbo.Pacientes P ON (i.IdPaciente = P.IdPaciente)
	JOIN [Hosma].dbo.eo_comercial_drugs E1 ON (T.IdFarmacoEO = E1.Comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs_comercial_drugs E2 ON (T.IdPaEo = E2.drug_comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs E3 ON (E2.drug_id = E3.drug_id)
	JOIN [Hosma].dbo.eo_prescription_pattern PF ON (Pf.Prescription_pattern_id = t.IdFrecuenciaEO)
	JOIN [Hosma].dbo.eo_administration_routes V ON (V.administration_route_id = T.IdViaAdministracionEO)
	JOIN [Hosma].dbo.eo_PrescripcionFrecuencia F ON (f.IdPrescripcionFrecuencia = t.IdPrescripcionFrecuencia)
	JOIN [Hosma].dbo.Almacen A ON (T.IdCodArt = A.IdCodArt)
	LEFT OUTER JOIN [Hosma].dbo.eo_solutions E4 ON (T.IdSolucion = E4.solution_id)
	JOIN Hosma.dbo.Organizacion o ON i.IdHospital = o.IdHospital
 
WHERE 
	o.NombreCorto LIKE 'MADRID' AND 
	DATEPART(year, i.FECHAINGRESO) BETWEEN '2019' AND '2023' AND 
	i.Anulado = 0 and 
	T.validado = 1 AND 
	I.IDINGRESO LIKE 1211070

	union all 

	SELECT

	i.IdPaciente, 
	i.idingreso as id_ingreso, 
	t.idtratamientofarm, 
	LEFT(e1.code_nac, LEN(e1.code_nac) - 1) as local_code,
	e1.name as nom_comercial, 
	PrincipioActivo2 as principio_activo 

FROM [Hosma-Doctor].dbo.TratamientoFarm T
 
	JOIN [Hosma].dbo.ingresos i ON (T.IdEpisodio = i.IdIngreso AND T.Tipo='I')
	JOIN [Hosma].dbo.Pacientes P ON (i.IdPaciente = P.IdPaciente)
	JOIN [Hosma].dbo.eo_comercial_drugs E1 ON (T.IdFarmacoEO = E1.Comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs_comercial_drugs E2 ON (T.IdPaEo = E2.drug_comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs E3 ON (E2.drug_id = E3.drug_id)
	JOIN [Hosma].dbo.eo_prescription_pattern PF ON (Pf.Prescription_pattern_id = t.IdFrecuenciaEO)
	JOIN [Hosma].dbo.eo_administration_routes V ON (V.administration_route_id = T.IdViaAdministracionEO)
	JOIN [Hosma].dbo.eo_PrescripcionFrecuencia F ON (f.IdPrescripcionFrecuencia = t.IdPrescripcionFrecuencia)
	JOIN [Hosma].dbo.Almacen A ON (T.IdCodArt = A.IdCodArt)
	LEFT OUTER JOIN [Hosma].dbo.eo_solutions E4 ON (T.IdSolucion = E4.solution_id)
	JOIN Hosma.dbo.Organizacion o ON i.IdHospital = o.IdHospital
 
WHERE 
	o.NombreCorto LIKE 'MADRID' AND 
	DATEPART(year, i.FECHAINGRESO) BETWEEN '2019' AND '2023' AND 
	i.Anulado = 0 and 
	T.validado = 1 AND 
	I.IDINGRESO LIKE 1211070


	union all 

	SELECT

	i.IdPaciente, 
	i.idingreso as id_ingreso, 
	t.idtratamientofarm, 
	LEFT(e1.code_nac, LEN(e1.code_nac) - 1) as local_code,
	e1.name as nom_comercial,
	PRINCIPIOACTIVO3 as principio_activo

FROM [Hosma-Doctor].dbo.TratamientoFarm T
 
	JOIN [Hosma].dbo.ingresos i ON (T.IdEpisodio = i.IdIngreso AND T.Tipo='I')
	JOIN [Hosma].dbo.Pacientes P ON (i.IdPaciente = P.IdPaciente)
	JOIN [Hosma].dbo.eo_comercial_drugs E1 ON (T.IdFarmacoEO = E1.Comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs_comercial_drugs E2 ON (T.IdPaEo = E2.drug_comercial_drug_id)
	JOIN [Hosma].dbo.eo_drugs E3 ON (E2.drug_id = E3.drug_id)
	JOIN [Hosma].dbo.eo_prescription_pattern PF ON (Pf.Prescription_pattern_id = t.IdFrecuenciaEO)
	JOIN [Hosma].dbo.eo_administration_routes V ON (V.administration_route_id = T.IdViaAdministracionEO)
	JOIN [Hosma].dbo.eo_PrescripcionFrecuencia F ON (f.IdPrescripcionFrecuencia = t.IdPrescripcionFrecuencia)
	JOIN [Hosma].dbo.Almacen A ON (T.IdCodArt = A.IdCodArt)
	LEFT OUTER JOIN [Hosma].dbo.eo_solutions E4 ON (T.IdSolucion = E4.solution_id)
	JOIN Hosma.dbo.Organizacion o ON i.IdHospital = o.IdHospital
 
WHERE 
	o.NombreCorto LIKE 'MADRID' AND 
	DATEPART(year, i.FECHAINGRESO) BETWEEN '2019' AND '2023' AND 
	i.Anulado = 0 and 
	T.validado = 1 AND 
	I.IDINGRESO LIKE 1211070

	) 
	
	select * from cte where principio_activo is not null and principio_activo not like ''
	order by id_tratamiento asc