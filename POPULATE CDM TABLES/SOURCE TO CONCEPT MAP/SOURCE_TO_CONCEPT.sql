
TRUNCATE TABLE BBDD_EMILIANODELIA.DBO.SOURCE_TO_CONCEPT_MAP 

USE HOSMA;

/* Recommended for use in ETL processes to maintain local source codes 
which are not available as Concepts in the Standardized Vocabularies, 
and to establish mappings for each source code into a Standard Concept 
as target_concept_ids that can be used to populate the Common Data Model tables. */ 

WITH CTE AS (

SELECT DISTINCT 

CodParametro as source_code, 
0 as source_concept_id,
'TIPOS_DE_INGRESO_HM' as source_vocabulary_id, 
PARAMETRODESCR AS source_code_description, 
CASE 
	WHEN CodParametro like 'U' /*urgencias*/ THEN  9203 --DOMAIN: VISIT / Emergency Room Visit
	WHEN CodParametro like 'A' /* ambulantes */ THEN 9202 -- DOMAIN: VISIT / OUTPATIENT VISIT
	WHEN CodParametro like 'D' /* admision */ OR -- We can assume the patient came from home			                                   
		 CodParametro like 'S' /*sin tipo */ THEN 0 -- we can assume he comes from home
ELSE NULL
END AS target_concept_id, 
'' AS target_vocabulary_id, 
'' as valid_start_date, 
'' as valid_end_date, 
'' as invalid_reason 

from hosma.dbo.Parametros 
where GrupoParametro like 'TPI'

union all 

/****************************/
/* TIPOS DE ALTA INGRESOS   */
/****************************/

SELECT DISTINCT 

CodParametro as source_code, 
0 as source_concept_id, 
'TIPOS_DE_ALTA_HM' AS source_vocabulary_id, 
CASE 
	WHEN GRUPOPARAMETRO LIKE 'MTA' THEN ParametroDescr +' (Ingresos)' 
	ELSE ParametroDescr + ' (Ambulantes)'
END AS source_code_description, 
CASE  

	/* MOTIVOS DE ALTA INGRESOS */
	WHEN CodParametro LIKE 'FU' OR -- Fuga --> the patient went home/ hence we put a 0 (ingresos)
		 CodParametro LIKE 'AV' OR -- Alta voluntaria means the patient went home (ingresos)
		 CodParametro = 'CM' THEN 0 -- Domicilio (ingresos)
	WHEN CodParametro = 'FC' THEN NULL -- No sé que poner acé tengo entendido que hay una tabla solo para muertes 
	WHEN CodParametro = 'TH' THEN 9202 -- 	Traslado al hospital (ingresos)
	WHEN CodParametro = 'TR' or --Traslado a un Centro Sociosanitario (ingresos)
		 CodParametro = 'TS'  THEN 8756 --Traslado a Hotel Sanitario (ingresos)

	/* MOTIVOS DE ALTA AMBULABTES */
	WHEN CodParametro LIKE 'G' /* TRASLADO A HOSPITAL DE GRUPO */ THEN 8756
	WHEN CodParametro LIKE 'C' /* DOMICILIO */ THEN 0 -- 
	WHEN CodParametro LIKE 'I' /* INGRESO */THEN 9201 --inpatient visit 
	WHEN CodParametro LIKE 'O' /* TRASLADO A OTROS HOSPITALES */ THEN 8756
	when CodParametro like 'Z' /* OTROS*/ THEN NULL
ELSE '' 
END AS target_concept_id, 

'' AS target_vocabulary_id, 
'' as valid_start_date, 
'' as valid_end_date, 
'' as invalid_reason 

from [hosma-doctor].dbo.Parametros 
where GrupoParametro in ('MTA', 'MAM') and Cabecera like 1

union all 
/************************/
/* PROVIDER SPECIALTIES */
/************************/

SELECT DISTINCT 

codparametro as source_code, 
0 as source_concept_id, 
'ESPECIALIADES_MEDICAS_HM' as source_vocabulary_id, 
p.parametrodescr as source_code_description, 

	CASE -- Vocabularies used --> NUCC / Medicare Specialty / ABMS /  / Domain: Provider
		WHEN P.ParametroDescr LIKE 'Alergologia'         THEN 38003830 -- Physician Specialty / Domain: Provider 
		when p.ParametroDescr like 'Analisis Clinicos'   THEN 38004692 --Clinical Laboratory
		when p.ParametroDescr like 'Anatomia Patologica' THEN 45756795 --Pathology - Anatomic
		when p.ParametroDescr like 'Anestesia'           THEN 38004450 --Anesthesiology
		when p.ParametroDescr like 'Audiologia'          THEN 38004489 -- 	Audiology
		when p.ParametroDescr like 'Cardiologia' or
			 p.ParametroDescr like 'Cardioresonancia' or 
			 p.ParametroDescr LIKE 'Imagen Cardíaca Avanzada' or 
			 p.ParametroDescr like 'Unidad de Ondas de Choque'   THEN 38004451 -- Cardiology
		when p.ParametroDescr like 'Cardiologia Pediatrica'      THEN 45756805 -- Pediatric Cardiology
		when p.ParametroDescr like 'Cirugia Cardiaca'            THEN 38004497 -- Cardiac Surgery 
		when p.ParametroDescr like 'Cirugia Cardiaca Pediatrica' THEN 44777760 -- Paediatric Cardiac Surgery
		when p.ParametroDescr like 'Cirugia General'             THEN 38004447 -- General Surgery 
		when p.ParametroDescr like 'Cirugia Maxilofacial'        THEN 38004504 -- Maxillofacial Surgery 
		when p.ParametroDescr like 'Cirugia Pediatrica'          THEN 45756819 -- Pediatric Surgery
		when p.ParametroDescr like 'Cirugia Plastica'            THEN 38004467 -- Plastic And Reconstructive Surgery
		when p.ParametroDescr like 'Cirugia Toracica'            THEN 38004473 -- Thoracic Surgery
		when p.ParametroDescr like 'Cirugia Vascular'            THEN 38004496 -- Vascular Surgery 
		when p.ParametroDescr like 'Dermatologia'                THEN 38004452 -- Dermatology 
		when p.ParametroDescr like 'Endocrinologia'              THEN 38004485 -- Endocrinology
		when p.ParametroDescr like 'Endocrinologia Pediatrica'   THEN 45756809 -- Pediatric Endocrinology
		when p.ParametroDescr like 'Gastroenterologia'			 THEN 38004455 -- Gastroenterology
		when p.ParametroDescr like 'Gastroenterologia Pediatrica' THEN 45756810 -- Pediatric Gastroenterology / ABMS
		when p.ParametroDescr like 'Ginecologia'	             THEN 38003902  -- Gynecology
		when p.ParametroDescr like 'Genetica Clinica' then 45756760	--Clinical Genetics (MD)
		when p.ParametroDescr like 'Hemodinamica' OR
			 p.ParametroDescr like 'Hematologia'				        THEN 38004501   --Hematology
		when p.ParametroDescr like 'Hematologia y Oncologia Pediatrica' THEN 45756811	--Pediatric Hematology-Oncology
		when p.ParametroDescr like 'Inmunologia Clinica'                THEN 44777719	--Clinical immunology
		WHEN p.ParametroDescr LIKE 'Logopedia'                          THEN 38004122 --Speech, Language and Hearing Specialist / Technologist
		WHEN p.ParametroDescr LIKE 'Matrona'                            THEN 38003807 -- Midwive
		WHEN p.ParametroDescr LIKE 'Medicina de Urgencias'              THEN 38004510 -- Emergency Medicine
		WHEN p.ParametroDescr LIKE 'Medicina del Trabajo'               THEN 44777713 -- Occupational Medicine
		WHEN p.ParametroDescr LIKE 'Medicina Familiar y Comunitaria'    THEN 38003851 -- Family Medicine
		WHEN p.ParametroDescr LIKE 'Medicina General'                   THEN 38004446 -- General Practice 
		WHEN p.ParametroDescr LIKE 'Medicina Intensiva'                 THEN 45756778 --Internal Medicine - Critical Care Medicine
		WHEN p.ParametroDescr LIKE 'Medicina Interna'                   THEN 38004456	 --Internal Medicine
		WHEN p.ParametroDescr LIKE 'Medicina Nuclear'                   THEN 38004476 -- Nuclear Medicine
		WHEN p.ParametroDescr LIKE 'Medicina Preventiva'                THEN 38004503 -- Preventive Medicine 
		WHEN p.ParametroDescr LIKE 'Microbiologia'                      THEN 45756800 -- Microbioology
		WHEN p.ParametroDescr LIKE 'Nefrologia'                         THEN 38004479 -- Nephrology
		WHEN p.ParametroDescr LIKE 'Neumologia'                         THEN 38004472 -- Pulmonary Disease
		WHEN p.ParametroDescr LIKE 'Neurocirugia'                       THEN 38004459 -- Neurosurgery
		WHEN p.ParametroDescr LIKE 'Neurofisiologia'                    THEN 45756763 -- Clinical Neurophysiology
		WHEN p.ParametroDescr LIKE 'Neurologia'                         THEN 38004458	--Neurology
		WHEN p.ParametroDescr LIKE 'Neurologia Pediatrica'              THEN 44777781  --Paediatric Neurology
		WHEN p.ParametroDescr LIKE 'Neuroradiologia'                    THEN 45756791 --Neuroradiology
		WHEN p.ParametroDescr LIKE 'Nutricion'                          THEN 38003688 --Nutricionist
		WHEN p.ParametroDescr LIKE 'Odontologia'                        THEN 903277 -- Dentistry
		WHEN p.ParametroDescr LIKE 'Oftalmologia'                       THEN 38004463 --Ophthalmology
		WHEN p.ParametroDescr LIKE 'Oncologia Medica'                   THEN 38004507 -- Medical Oncology
		WHEN p.ParametroDescr LIKE 'Oncologia Radioterapica'            THEN 38004509 --Radiation Oncology
		WHEN p.ParametroDescr LIKE 'Otorrinolaringologia'               THEN 38004449 --Otolaryngology
		WHEN p.ParametroDescr LIKE 'Medicina Estetica'                  THEN 38004185 -- Other technician
		WHEN p.ParametroDescr LIKE 'Pediatria'                                           THEN 38004477  --Pediatric Medicine
		WHEN p.ParametroDescr LIKE 'Podologia'                                           THEN 38004030	--Podiatrist
		WHEN p.ParametroDescr LIKE 'Psicologia'                                          THEN 38004488 --Psychology
		WHEN p.ParametroDescr LIKE 'Psiquiatria'                                         THEN 38004469	 --Psychiatry
		WHEN p.ParametroDescr LIKE 'Radiologia'                                          THEN 45756825 -- Radiology
		WHEN p.ParametroDescr LIKE 'Radiologia Vascular'                                 THEN 45756833 -- Vascular and Interventional Radiology
		WHEN p.ParametroDescr LIKE 'Rehabilitacion'                                      THEN 44777808 -- Intermediate care (encompasses a range of multidisciplinary services designed to safeguard independence by maximising rehabilitation and recovery)
		WHEN p.ParametroDescr LIKE 'Reumatologia'                                        THEN 38004491 -- Rheumatology
		WHEN p.ParametroDescr LIKE 'Tratamiento del dolor'                               THEN 38004494 -- Pain Management
		WHEN p.ParametroDescr LIKE 'Traumatologia'                                       THEN 38003915 --Orthopaedic Trauma Surgery
		WHEN p.ParametroDescr LIKE 'Traumatologia Pediatrica'                            THEN 44777753 --Paediatric Trauma and Orthopaedics
		WHEN p.ParametroDescr LIKE 'Urologia'                                            THEN 38004474	--Urology

		-- mas especialidades 
		when p.ParametroDescr like 'Nefrologia Pediatrica' then 45756813	--Pediatric Nephrology
		WHEN p.ParametroDescr LIKE 'Cardiopatías Congénitas y Cardiología Pediátrica' THEN 45756805 --Pediatric Cardiology
		WHEN p.ParametroDescr LIKE 'Control Natural de la Fertilidad' THEN 45756826	--Reproductive Endocrinology / Infertility
		WHEN p.ParametroDescr LIKE 'Ecocardiografía Fetal' THEN 45756780	--Maternal and Fetal Medicine
		WHEN p.ParametroDescr LIKE 'Fertility Center' THEN 45756826 --Reproductive Endocrinology / Infertility
		WHEN p.ParametroDescr LIKE 'Fisioterapia' THEN 38004490 -- physical therapist
		WHEN p.ParametroDescr LIKE 'Geriatría' THEN 38004478 -- geriatric medicine 
		WHEN p.ParametroDescr LIKE 'Ginecología Oncológica' THEN 38004513 -- Gynecology / Oncology
		WHEN p.ParametroDescr LIKE 'Hemodiálisis' THEN 38003735 --Registered Hemodialysis Nurse
		WHEN p.ParametroDescr LIKE 'Infectología pediátrica' THEN 45756812 --Pediatric Infectious Diseases
		WHEN p.ParametroDescr LIKE 'Medicina del Deporte' THEN 903256 -- sports medicine 
		WHEN p.ParametroDescr LIKE 'Medicina Hiperbárica' THEN 45756832 --Undersea and Hyperbaric Medicine
		WHEN p.ParametroDescr LIKE 'Neumología Pediátrica' THEN 45756815 -- Pediatric Pulmonology
		WHEN p.ParametroDescr LIKE 'Neurocirugía Pediátrica' THEN 44777757 -- paediatric neurosurgery 
		WHEN p.ParametroDescr LIKE 'Neuropsicología' THEN 38004505 -- neuropsychiatry 
		WHEN p.ParametroDescr LIKE 'Odontología Pediátrica' THEN 38003677 -- Pediatric Dentistry
		WHEN p.ParametroDescr LIKE 'Oncología Médica' THEN 38004507 -- medical oncology 
		WHEN p.ParametroDescr LIKE 'Ortodoncia' THEN 44777673	--Orthodontics
		WHEN p.ParametroDescr LIKE 'Psicología Infantil' THEN 38003640	--Clinical Child and Adolescent Psychologist
		WHEN p.ParametroDescr LIKE 'Psiquiatría Infanto-juvenil' THEN 45756756	--Child and Adolescent Psychiatry
		WHEN p.ParametroDescr LIKE 'Radiología Pediátrica' THEN 45756816	--Pediatric Radiology
		WHEN p.ParametroDescr LIKE 'Radiología Vascular Intervencionista' THEN 45756833	--Vascular and Interventional Radiology
		WHEN p.ParametroDescr LIKE 'Reumatología Pediátrica' THEN 45756818	--Pediatric Rheumatology
		WHEN p.ParametroDescr LIKE 'Trabajo Social' THEN 38004499	--Social Worker
		WHEN p.ParametroDescr LIKE 'Tratamiento acupuntura' THEN 38003780	--Acupuncturist
		WHEN p.ParametroDescr LIKE 'Unidad de Cuidados Domiciliarios' THEN 38004436	--Home Health Aide
		WHEN p.ParametroDescr LIKE 'Unidad de Endoscopia Bariátrica' THEN 38004455 -- Gastroenterology
		WHEN p.ParametroDescr LIKE 'Unidad de Hospitalización a Domicilio' THEN 38004436	--Home Health Aide
		WHEN p.ParametroDescr LIKE 'Unidad de Medicina Integral del Adolescente' THEN 45756747	--Adolescent Medicine
		WHEN p.ParametroDescr LIKE 'Unidad de Medicina Molecular' THEN 45756762--Clinical Molecular Genetics
		WHEN p.ParametroDescr like 'Quirofano' then 38004447 -- General Surgery
		WHEN p.ParametroDescr LIKE 'Unidad del Dolor' THEN 38004494	--Pain Management
		WHEN p.ParametroDescr LIKE 'Urología Pediátrica' THEN 45756821	--Pediatric Urology
		WHEN p.ParametroDescr LIKE 'USOC' THEN 38004488 -- psychology
		when p.ParametroDescr like 'Electrofisiología Cardíaca' then 903274	--Clinical Cardiac Electrophysiology
		when p.ParametroDescr like 'Enfermeria' then 32581	--Nurse

	ELSE 32577 --Code for Physician which is a synonym of Unknown Physician Specialty 

END AS target_concept_id, 
'' as target_vocabulary_id,
'' AS valid_start_date, 
'' as valid_end_date, 
'' as invalid_reason

FROM Parametros p 
WHERE 
	p.GrupoParametro LIKE 'DEP' and 
	p.ParametroDescr not like '%ensayo%' and 
	p.ParametroDescr not like '%EECC%' and 
	p.ParametroDescr not like 'no usar' and
	p.cabecera like 1
UNION ALL

/***********************/
/*      DRUG ROUTES    */
/***********************/
/*
SELECT 

V.code as source_code, 
0 as source_concept_id, 
'RUTAS_ADMIN_MEDICAMENTOS_HM' as source_vocabulary_id, 
V.NAME AS source_code_description, 

CASE
	WHEN v.CODE LIKE 'INH' OR --RESPIRATORY TRACK 
		    V.CODE LIKE 'NEB' THEN 40486069  --
	WHEN V.CODE LIKE 'NASAL' THEN 4262914	--Nasal
	WHEN V.CODE LIKE 'IP' THEN 4156707  -- INTRAPLEURAL ROUTE
	WHEN V.CODE LIKE 'INL' THEN 4157758 -- INTROLESIONAL ROUTE
	WHEN V.CODE LIKE 'ORAL' THEN 4132161 -- ORAL ROUTE
	WHEN V.CODE LIKE 'IM' THEN 4302612 --INTRAMUSCULAR ROUTE
	WHEN V.CODE LIKE 'REC' OR
			V.CODE LIKE 'INTRARECTAL' THEN 4290759 -- RECTAL ROUTE
	WHEN V.CODE LIKE 'IV' THEN 4171047 -- INTRAVENOUS ROUTE
	WHEN V.CODE LIKE 'INVE' THEN 4186838 -- INTRAVESICAL ROUTE
	WHEN V.CODE LIKE 'NASAL ' THEN 4262914 -- NASAL ROUTE
	WHEN V.CODE LIKE 'PSC' OR 
			V.CODE LIKE 'SC' THEN 4142048 -- SUBCUTANEOUS ROUTE
	WHEN V.CODE LIKE 'OTICA' OR
			V.CODE LIKE 'OFT' THEN 4184451 -- OPTHALMIC ROUTE
	WHEN V.CODE LIKE 'PARAVERTEBRAL' THEN 4170267  --PARAVERTEBRAL ROUTE
	WHEN V.CODE LIKE 'SONDA PEG' THEN 40492301 -- INTRAGASTRIC (CONCEPT SYNONYM)
	WHEN V.CODE LIKE 'SL' THEN 4292110 -- SUBLINGUAL ROUTE
	WHEN V.CODE LIKE 'TOP' OR 
			v.CODE LIKE 'LOCAL' OR
			V.CODE LIKE 'TOP BUC' THEN 4263689 --TOPICAL ROUTE
	WHEN V.CODE LIKE 'TD' THEN 4262099 -- TRANSDERMAL ROUTE
	WHEN V.CODE LIKE 'VAG' THEN 4057765	--Vaginal
	when v.CODE like 'SNG' THEN 4132711 --Nasogastric Route

	WHEN V.CODE LIKE 'CAM' THEN 4303409 --Intracameral
	WHEN V.CODE LIKE 'ED' THEN 4186831	--Endocervical
	WHEN V.CODE LIKE 'EPI' THEN 4225555	--Epidural
	WHEN V.CODE LIKE 'EPILE' THEN 35608078	--Epilesional
	WHEN V.CODE LIKE 'HEMODIAL' THEN 35624178	--Extracorporeal hemodialysis
	WHEN V.CODE LIKE 'HEMOFILT' THEN 44801748	--Haemodiafiltration
	WHEN V.CODE LIKE 'IA' AND V.NAME LIKE 'INTRAARTERIAL' THEN 4240824	--Intra-arterial
	WHEN V.CODE LIKE 'IA' AND V.NAME LIKE 'INTRARTICULAR' THEN 4006860	--Intra-articula
	WHEN V.CODE LIKE 'ICA' THEN 4156705	--Intracardiac
	WHEN V.CODE LIKE 'ID' THEN 4156706	--Intradermal
	WHEN V.CODE LIKE 'IMPL' THEN NULL -- Implantacion does not seem to have an equivalent 
	WHEN v.code like 'INA' THEN  4006860	--Intra-articula
	WHEN V.CODE LIKE 'IND' THEN 4163769	--Intradiscal 
	WHEN V.CODE LIKE 'INP' THEN 4243022	--Intraperitoneal
	WHEN V.CODE LIKE 'INTRACAVERN' THEN 4157757	--Intracavernous
	WHEN V.CODE LIKE 'INTRAVIT' THEN 4302785	--Intravitreal
	WHEN V.CODE LIKE 'IO' THEN 4157760	--Intraocula
	WHEN V.CODE LIKE 'IR' THEN 4229543	--Intratracheal
	WHEN V.CODE LIKE 'IS' THEN 4302352	--Intrasynovial
	WHEN V.CODE LIKE 'IT' THEN 4217202	--Intrathecal
	WHEN V.CODE LIKE 'ITR' THEN 4229543	--Intratracheal
	WHEN V.CODE LIKE 'ITT' THEN 46272926	--Intramural
	WHEN V.CODE LIKE 'IU' THEN 4233974	--Urethral
	WHEN V.CODE LIKE 'PERINEURAL' THEN 4157761	--Perineural
	WHEN V.CODE LIKE 'PERIOSEO' THEN 4171893	--Periosteal
	WHEN V.CODE LIKE 'PIV' THEN 4171047	--Intravenous
	WHEN V.CODE LIKE 'SND' THEN 4172316	--Nasoduodenal
	WHEN V.CODE LIKE 'SNY' THEN 4305834	--Nasojejunal
	WHEN V.CODE LIKE 'SONDA PEJ' THEN 4133177	--Jejunostomy 
	WHEN V.CODE LIKE 'SUBCONJUNTIVAL' THEN 4163770	--Subconjunctival
	WHEN V.CODE LIKE 'SUBMUC' THEN 4169634	--Submucosal
	WHEN V.CODE LIKE 'SUPRAVLAV' THEN NULL --Did not found a match 
	when v.code like 'TIMPANICA' THEN 4168656--Intratympanic
	WHEN V.CODE LIKE 'UTERINA' THEN 4269621	--Intrauterin
	WHEN V.CODE LIKE 'VTR' THEN 4222259	--Intraventricular route - cardiac
ELSE NULL 
END AS target_concept_id, 
'' as target_vocabulary_id, 
'' as valid_start_date,
'' as valid_end_date, 
'' as invalid_reason

FROM eo_administration_routes V

UNION ALL 

*/

/***********************/
/*       GENDER        */
/***********************/

SELECT DISTINCT 

CodParametro as source_code, 
0 as source_concept_id, 
'CODIGO_SEXO_HM' AS source_vocabulary_id, 
ParametroDescr as source_code_description, 
CASE 
    WHEN CodParametro = 1 THEN 8507  -- DOMAIN: GENDER 
    WHEN CodParametro = 2 THEN 8532  -- DOMAIN: GENDER
    ELSE NULL  -- UNKNOWN SEX / DOMAIN: GENDER 
END AS target_concept_id, 
'' as target_vocabulary_id, 
'' as valid_start_date,
'' as valid_end_date, 
'' as invalid_reason

FROM Parametros 
WHERE 
	GrupoParametro like 'SEX' and 
	Cabecera like 1 AND 
	ParametroDescr NOT LIKE 3 /* THERE IS NOT STD CONCEPT FOR INDETERMINADO, THEREFORE WE EXCLUDE IT */

UNION ALL 

/***********************/
/*   CONDITION STATUS  */
/***********************/

SELECT DISTINCT 

	f.tipo + '-' + f.POAD as source_code, 
	0 as source_concept_id, 
	'ESTATUS_DIAGNOSTICOS_HM' AS source_vocabulary_id, 
	--'' as test, 
	CASE
		WHEN f.Tipo = 'P' AND F.POAD LIKE 'S'THEN 'Dx Primario Presente en el momento del Ingreso'
		WHEN F.Tipo = 'P' AND F.POAD LIKE 'D' THEN 'Dx Primario / Documentación insuficiente para determinar si la condición esté presente o no al momento del ingreso'
		WHEN F.Tipo = 'P' AND F.POAD LIKE 'E' THEN 'Dx Primario Exento de Informar POA'
		WHEN f.Tipo = 'p' and F.POAD like 'N' THEN 'Dx Primario No presente en el episodio'
		WHEN f.Tipo = 'S' AND F.POAD = 'S' THEN 'Dx Secundario Presente en el Ingreso'
		WHEN f.Tipo = 'S' AND F.POAD = 'I' THEN 'Dx Secundario / No puede determinarse clínicamente si la condición estaba o no presente en el ingreso'
		WHEN f.Tipo = 'S' AND F.poad = 'N' THEN 'Dx Secundario No Presente en el Episodio'
		WHEN f.Tipo = 'S' AND F.POAD = 'E' THEN 'Dx Secundario Exento de Informar POA'
		WHEN f.Tipo = 'S' AND F.POAD = 'D' THEN 'Dx Secundario / Documentación insuficiente para determinar si la condición esté presente o no al momento del ingreso'
		ELSE NULL
	END AS source_code_description, 
	CASE 
		/*When the Dx is marked as primary this always means that the Dx was present in the episode */
		WHEN f.Tipo = 'P' THEN 32901 -- Vocab: Condition Status / Admission Diagnosis 
		/*When the Dx is secondary but is also present in the episode  */
		WHEN f.Tipo ='S' AND f.POAD = 'S' THEN 32907 -- Vocab: Condition Status / Secondary Admission Diagnosis
		/* Any other classifications of a secondary Dx belongs as a plain Secondary Dx*/
		ELSE 32908 -- Vocab: Condition Status / Secondary Diagnosis 
	END AS target_concept_id, 
	'' as target_vocabulary_id, 
	'' as valid_start_date,
	'' as valid_end_date, 
	'' as invalid_reason

FROM HOSMA.DBO.FichaDMedica10 F 
WHERE F.Tipo IN ('P', 'S')

UNION ALL 

SELECT DISTINCT 

unidades AS source_code, 
0 as source_concept_id, 
'UNIDADES_LABORATORIOS_ANALITICAS_HM' AS source_vocabulary_id, 
unidades as source_code_description, 
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

		when LAB.unidades = 'ng/dL' then 8817	--milligram per deciliter
		when LAB.unidades = 'ng/L' then 8725 -- nanogram per liter
		when LAB.unidades = 'ng/mL' then 8842 -- nanogram per milliliter

		when lab.unidades = 'ng/mL/h' then 8992	--nanogram per deciliter per hour

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
	end as targat_concept_id, 
'' as target_vocabulary_id, 
'' as valid_start_date,
'' as valid_end_date, 
'' as invalid_reason

FROM [Hosma-Doctor].DBO.LaboratorioResultados_lab lab


)


/* INSERT INTO */

INSERT INTO BBDD_EmilianoDelia.DBO.SOURCE_TO_CONCEPT_MAP (

	source_code,
	source_concept_id, 
	source_vocabulary_id, 
	source_code_description,
	
	/* for checking */
	--con.concept_name, 
	--con.concept_code, 
	--con.standard_concept, 
	
	target_concept_id, 
	target_vocabulary_id, 
	valid_start_date,
	valid_end_date, 
	invalid_reason)

/* SELECT DATA TO INSERT INTO TABLE */
SELECT

	source_code,
	source_concept_id, 
	source_vocabulary_id, 
	source_code_description,

	/* for checking */
	--con.concept_name, 
	--con.concept_code, 
	--con.standard_concept, 

	temp.target_concept_id, 

	con.vocabulary_id as target_vocabulary_id, 
	CAST(GETDATE() AS DATE) AS valid_start_date,
	'31-12-2099' AS valid_end_date, 
	temp.invalid_reason

from cte temp
join BBDD_EmilianoDelia.dbo.CONCEPT con on con.concept_id = temp.target_concept_id

ORDER BY source_vocabulary_id  ASC
