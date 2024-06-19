use Hosma

select 

i.IdPaciente as id_paciente, 
i.IdIngreso as id_episodio, 
'ingreso' as tipo_episodio, 
i.FechaIngreso as fecha_ingreso, 
f.Tipo, 
CASE 
	WHEN cie10.TipoCIE10 LIKE 'D' THEN 'dx' 
	WHEN CIE10.TipoCIE10 LIKE 'P' THEN 'procedure' 
else ''
END AS tipo_cie10, 
cie10.CodigoCIE10 as cod_cie10, 
cie10.Descripcion as desc_cie10

FROM [Hosma].DBO.ingresos i
LEFT JOIN ORGANIZACION O ON o.IDHOSPITAL = i.IdHospital
 
-- TABLAS DE REFERENCIA CIE-10
JOIN Hosma.DBO.DMedica D ON (i.IdIngreso = D.IdEpisodio AND D.TIPOEPISODIO = 'i')
JOIN Hosma.DBO.FichaDMedica10 F ON D.IdDMedica = F.IdDMedica
JOIN HOSMA.DBO.CIE10 ON F.IdCie10 = CIE10.IdCIE10
where i.IdIngreso like 866045 
order by tipo_cie10, cod_cie10 asc