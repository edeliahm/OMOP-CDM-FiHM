USE BBDD_EmilianoDelia

IF OBJECT_ID('bbdd_emilianodelia.dbo.CONDITION_OCCURRENCE', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.CONDITION_OCCURRENCE

	--HINT DISTRIBUTE ON KEY (person_id)
	CREATE TABLE BBDD_EmilianoDelia.dbo.CONDITION_OCCURRENCE (
	condition_occurrence_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	condition_concept_id integer NOT NULL,
	condition_start_date date NOT NULL,
	condition_start_datetime datetime NULL,
	condition_end_date date NULL,
	condition_end_datetime datetime NULL,
	condition_type_concept_id integer NOT NULL,
	condition_status_concept_id integer NULL,
	stop_reason varchar(max) NULL,
	provider_id integer NULL,
	visit_occurrence_id integer NULL,
	visit_detail_id integer NULL,
	condition_source_value varchar(MAX) NULL,
	condition_source_concept_id integer NULL,
	condition_status_source_value varchar(max) NULL);
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.DEATH', 'U') IS NULL

BEGIN
	--DROP TABLE BBDD_EMILIANODELIA.DBO.DEATH 
	CREATE TABLE bbdd_emilianodelia.dbo.DEATH (
	person_id INT PRIMARY KEY NONCLUSTERED,
	death_date DATE,
	death_datetime DATETIME,
	death_type_concept_id INT,
	cause_concept_id INT,
	cause_source_value VARCHAR(50),
	cause_source_concept_id INT);
END

IF OBJECT_ID('bbdd_emilianodelia.dbo.DRUG_EXPOSURE', 'U') IS NULL
BEGIN
	--DROP TABLE BBDD_EMILIANODELIA.DBO.DRUG_EXPOSURE

	CREATE TABLE bbdd_emilianodelia.dbo.DRUG_EXPOSURE (
	drug_exposure_id INT PRIMARY KEY NONCLUSTERED IDENTITY(1, 1),
	person_id INT,
	drug_concept_id INT,
	drug_exposure_start_date DATE,
	drug_exposure_start_datetime DATETIME,
	drug_exposure_end_date DATE,
	drug_exposure_end_datetime DATETIME,
	verbatim_end_date DATE,
	drug_type_concept_id INT,
	stop_reason VARCHAR(20),
	refills INT,
	quantity FLOAT,
	days_supply INT,
	sig VARCHAR(MAX),
	route_concept_id INT,
	lot_number VARCHAR(50),
	provider_id INT,
	visit_occurrence_id INT,
	visit_detail_id INT,
	drug_source_value VARCHAR(50),
	drug_source_concept_id INT,
	route_source_value VARCHAR(50),
	dose_unit_source_value VARCHAR(50));
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.OBSERVATION', 'U') IS NOT NULL
BEGIN
	--DROP TABLE BBDD_EMILIANODELIA.DBO.OBSERVATION 

	CREATE TABLE BBDD_EmilianoDelia.dbo.OBSERVATION (
	observation_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	observation_concept_id integer NOT NULL,
	observation_date date NOT NULL,
	observation_datetime datetime NULL,
	observation_type_concept_id integer NOT NULL,
	value_as_number float NULL,
	value_as_string varchar(60) NULL,
	value_as_concept_id Integer NULL,
	qualifier_concept_id integer NULL,
	unit_concept_id integer NULL,
	provider_id integer NULL,
	visit_occurrence_id integer NULL,
	visit_detail_id integer NULL,
	observation_source_value varchar(50) NULL,
	observation_source_concept_id integer NULL,
	unit_source_value varchar(50) NULL,
	qualifier_source_value varchar(50) NULL,
	value_source_value varchar(50) NULL,
	observation_event_id bigint NULL,
	obs_event_field_concept_id integer NULL
);
END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.OBSERVATION_PERIOD', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.OBSERVATION_PERIOD

	CREATE TABLE BBDD_EmilianoDelia.dbo.OBSERVATION_PERIOD (
	observation_period_id integer PRIMARY KEY NONCLUSTERED IDENTITY(1,1),
	person_id integer NOT NULL,
	observation_period_start_date date NOT NULL,
	observation_period_end_date date NOT NULL,
	period_type_concept_id integer NOT NULL
		);
END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.PERSON', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.PERSON 

	--HINT DISTRIBUTE ON KEY (person_id)
	CREATE TABLE BBDD_EmilianoDelia.dbo.PERSON (
	person_id integer PRIMARY KEY NONCLUSTERED, -- SETTING PK AND INDEX AT ONCE 
	gender_concept_id integer,
	year_of_birth integer NOT NULL,
	month_of_birth integer NULL,
	day_of_birth integer NULL,
	birth_datetime datetime NULL,
	race_concept_id integer NOT NULL,
	ethnicity_concept_id integer NOT NULL,
	location_id integer NULL,
	provider_id integer NULL,
	care_site_id bigint NULL,
	person_source_value varchar(50) NULL,
	gender_source_value varchar(50) NULL,
	gender_source_concept_id integer NULL,
	race_source_value varchar(50) NULL,
	race_source_concept_id integer NULL,
	ethnicity_source_value varchar(50) NULL,
	ethnicity_source_concept_id integer NULL);

END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.PROCEDURE_OCCURRENCE', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.PROCEDURE_OCCURRENCE

	CREATE TABLE bbdd_emilianodelia.dbo.PROCEDURE_OCCURRENCE (
	procedure_occurrence_id INT PRIMARY KEY NONCLUSTERED,
	person_id INT,
	procedure_concept_id INT,
	procedure_date DATE,
	procedure_datetime DATETIME,
	procedure_end_date DATE,
	procedure_end_datetime DATETIME,
	procedure_type_concept_id INT,
	modifier_concept_id INT,
	quantity INT,
	provider_id INT,
	visit_occurrence_id INT,
	visit_detail_id INT,
	procedure_source_value VARCHAR(50),
	procedure_source_concept_id INT,
	modifier_source_value VARCHAR(50));
END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.PROVIDER', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.PROVIDER
--HINT DISTRIBUTE ON RANDOM
	CREATE TABLE BBDD_EmilianoDelia.dbo.PROVIDER (
	provider_id integer PRIMARY KEY NONCLUSTERED,
	provider_name varchar(255) NULL,
	npi varchar(20) NULL,
	dea varchar(20) NULL,
	specialty_concept_id integer NULL, --REFERENCES BBDD_EmilianoDelia.dbo.CONCEPT(CONCEPT_ID),
	care_site_id bigint NULL,
	year_of_birth integer NULL,
	gender_concept_id integer NULL,
	provider_source_value varchar(50) NULL,
	specialty_source_value varchar(50) NULL,
	specialty_source_concept_id integer NULL,
	gender_source_value varchar(50) NULL,
	gender_source_concept_id integer NULL );
END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.VISIT_OCCURRENCE', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.VISIT_OCCURRENCE

	--HINT DISTRIBUTE ON KEY (person_id)
	CREATE TABLE BBDD_EmilianoDelia.dbo.VISIT_OCCURRENCE (
	visit_occurrence_id INT PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	visit_concept_id integer NOT NULL,
	visit_start_date date NOT NULL,
	visit_start_datetime datetime NULL,
	visit_end_date date NOT NULL,
	visit_end_datetime datetime NULL,
	visit_type_concept_id Integer NOT NULL,
	provider_id integer NULL,
	care_site_id bigint NULL,
	visit_source_value varchar(50) NULL,
	visit_source_concept_id integer NULL,
	admitted_from_concept_id integer NULL,
	admitted_from_source_value varchar(50) NULL,
	discharged_to_concept_id integer NULL,
	discharged_to_source_value varchar(50) NULL,
	preceding_visit_occurrence_id integer NULL );
END;


IF OBJECT_ID('bbdd_emilianodelia.dbo.CARE_SITE', 'U') IS NULL
BEGIN
	--DROP TABLE BBDD_EmilianoDelia.DBO.CARE_SITE 

	CREATE TABLE BBDD_EmilianoDelia.dbo.CARE_SITE (
	care_site_id bigint PRIMARY KEY NONCLUSTERED,
	care_site_name varchar(255) NULL,
	place_of_service_concept_id integer NULL,
	location_id integer NULL,
	care_site_source_value varchar(100) NULL,
	place_of_service_source_value varchar(50) NULL );
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.LOCATION', 'U') IS NOT NULL
BEGIN

	DROP TABLE BBDD_EmilianoDelia.DBO.LOCATION

	--HINT DISTRIBUTE ON RANDOM
	CREATE TABLE BBDD_EmilianoDelia.dbo.LOCATION (
	location_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
	address_1 varchar(MAX) NULL,
	address_2 varchar(MAX) NULL,
	city varchar(50) NULL,
	state varchar(MAX) NULL,
	zip varchar(9) NULL,
	county varchar(MAX) NULL,
	location_source_value varchar(50) NULL,
	country_concept_id integer NULL,
	country_source_value varchar(80) NULL,
	latitude float NULL,
	longitude float NULL );
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.VISIT_DETAIL', 'U') IS NULL
BEGIN

	--DROP TABLE VISIT_DETAIL;

	--HINT DISTRIBUTE ON RANDOM
	CREATE TABLE BBDD_EmilianoDelia.dbo.VISIT_DETAIL (
	visit_detail_id INT PRIMARY KEY NONCLUSTERED,
	person_id INT NOT NULL,
	visit_detail_concept_id INT NOT NULL,
	visit_detail_start_date DATE,
	visit_detail_start_datetime DATETIME,
	visit_detail_end_date DATE,
	visit_detail_end_datetime DATETIME,
	visit_detail_type_concept_id INT NOT NULL,
	provider_id INT,
	care_site_id BIGINT,
	visit_detail_source_value VARCHAR(50),
	visit_detail_source_concept_id INT,
	admitted_from_concept_id INT,
	admitted_from_source_value VARCHAR(50),
	discharged_to_source_value VARCHAR(50),
	discharged_to_concept_id INT,
	preceding_visit_detail_id INT,
	parent_visit_detail_id INT,
	visit_occurrence_id INT);
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.CDM_SOURCE', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.CDM_SOURCE

	--HINT DISTRIBUTE ON RANDOM
	CREATE TABLE CDM_SOURCE (
	cdm_source_name varchar(255) NOT NULL,
	cdm_source_abbreviation varchar(25) NOT NULL,
	cdm_holder varchar(255) NOT NULL,
	source_description varchar(MAX),
	source_documentation_reference varchar(255),
	cdm_etl_reference varchar(255),
	source_release_date date NOT NULL,
	cdm_release_date date NOT NULL,
	cdm_version varchar(10),
	cdm_version_concept_id integer NOT NULL,
	vocabulary_version varchar(20) NOT NULL
);
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.COHORT', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.COHORT

	--HINT DISTRIBUTE ON RANDOM
	CREATE TABLE COHORT (
	cohort_definition_id integer NOT NULL,
	subject_id integer NOT NULL,
	cohort_start_date date NOT NULL,
	cohort_end_date date
);
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.EPISODE', 'U') IS NULL
BEGIN
	
	--DROP TABLE BBDD_EmilianoDelia.DBO.EPISODE

	CREATE TABLE EPISODE (
	episode_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	episode_concept_id integer NOT NULL,
	episode_start_date date NOT NULL,
	episode_start_datetime datetime,
	episode_end_date date,
	episode_end_datetime datetime,
	episode_parent_id integer,
	episode_number integer,
	episode_object_concept_id integer NOT NULL,
	episode_type_concept_id integer NOT NULL,
	episode_source_value varchar(50),
	episode_source_concept_id integer
	);
END;

IF OBJECT_ID('bbdd_emilianodelia.dbo.EPISODE_EVENT', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.EPISODE_EVENT

	CREATE TABLE BBDD_EMILIANODELIA.DBO.EPISODE_EVENT(
	episode_id int not null, 
	event_id int not null, 
	episode_event_field_concept_id int not null 
);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.MEASUREMENT', 'U') IS NULL
BEGIN

	--DROP TABLE BBDD_EMILIANODELIA.DBO.MEASUREMENT

	CREATE TABLE MEASUREMENT (
	measurement_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	measurement_concept_id integer NOT NULL,
	measurement_date date NOT NULL,
	measurement_datetime datetime,
	measurement_time varchar(10),
	measurement_type_concept_id integer NOT NULL,
	operator_concept_id integer,
	value_as_number float,
	value_as_concept_id integer,
	unit_concept_id integer,
	range_low float,
	range_high float,
	provider_id integer,
	visit_occurrence_id integer,
	visit_detail_id integer,
	measurement_source_value varchar(50),
	measurement_source_concept_id integer,
	unit_source_value varchar(50),
	unit_source_concept_id integer,
	value_source_value varchar(50),
	measurement_event_id integer,
	meas_event_field_concept_id integer);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.META_DATA', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.META_DATA

	CREATE TABLE META_DATA (
	metadata_id integer PRIMARY KEY NONCLUSTERED,
	metadata_concept_id integer NOT NULL,
	metadata_type_concept_id integer NOT NULL,
	name varchar(250) NOT NULL,
	value_as_string varchar(250),
	value_as_concept_id integer,
	value_as_number float,
	metadata_date date,
	metadata_datetime datetime);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.COHORT_DEFINITION', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.COHORT_DEFINITION

	CREATE TABLE COHORT_DEFINITION (
	cohort_definition_id integer PRIMARY KEY NONCLUSTERED,
	cohort_definition_name varchar(255) NOT NULL,
	cohort_definition_description varchar(MAX),
	definition_type_concept_id integer NOT NULL,
	cohort_definition_syntax varchar(MAX),
	subject_concept_id integer NOT NULL,
	cohort_initiation_date date
);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.CONDITION_ERA', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.CONDITION_ERA

	CREATE TABLE BBDD_EmilianoDelia.DBO.CONDITION_ERA (
	condition_era_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	condition_concept_id integer NOT NULL,
	condition_era_start_date date NOT NULL,
	condition_era_end_date date NOT NULL,
	condition_occurrence_count integer,
);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.DOSE_ERA', 'U') IS NULL 
BEGIN
	--DROP TABLE BBDD_EmilianoDelia.DBO.DOSE_ERA 

	CREATE TABLE BBDD_EMILIANODELIA.DBO.DOSE_ERA (
	dose_era_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	drug_concept_id integer NOT NULL,
	unit_concept_id integer NOT NULL,
	dose_value float NOT NULL,
	dose_era_start_date date NOT NULL,
	dose_era_end_date date NOT NULL);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.COST', 'U') IS NULL 
BEGIN
	--DROP TABLE BBDD_EmilianoDelia.DBO.COST

	CREATE TABLE COST (
	cost_id integer PRIMARY KEY NONCLUSTERED,
	cost_event_id integer,
	cost_domain_id varchar(20) NOT NULL,
	cost_type_concept_id integer NOT NULL,
	currency_concept_id integer,
	total_charge float,
	total_cost float,
	total_paid float,
	paid_by_payer float,
	paid_by_patient float,
	paid_patient_copay float,
	paid_patient_coinsurance float,
	paid_patient_deductible float,
	paid_by_primary float,
	paid_ingredient_cost float,
	paid_dispensing_fee float,
	payer_plan_period_id integer,
	amount_allowed float,
	revenue_code_concept_id integer,
	revenue_code_source_value varchar(50),
	drg_concept_id integer,
	drg_source_value varchar(3));
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.DEVICE_EXPOSURE', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.DEVICE_EXPOSURE

	CREATE TABLE BBDD_EmilianoDelia.DBO.DEVICE_EXPOSURE (
	device_exposure_id integer PRIMARY KEY NONCLUSTERED,
	person_id integer NOT NULL,
	device_concept_id integer NOT NULL,
	device_exposure_start_date date NOT NULL,
	device_exposure_start_datetime datetime,
	device_exposure_end_date date,
	device_exposure_end_datetime datetime,
	device_type_concept_id integer NOT NULL,
	unique_device_id varchar(255),
	production_id varchar(255),
	quantity integer,
	provider_id integer,
	visit_occurrence_id integer,
	visit_detail_id integer,
	device_source_value varchar(50),
	device_source_concept_id integer,
	unit_concept_id integer,
	unit_source_value varchar(50),
	unit_source_concept_id integer);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.DRUG_STRENGTH', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.DRUG_STRENGTH

	CREATE TABLE bbdd_emilianodelia.dbo.DRUG_STRENGTH (
	drug_concept_id integer NOT NULL,
	ingredient_concept_id integer NOT NULL,
	amount_value float,
	amount_unit_concept_id integer,
	numerator_value float,
	numerator_unit_concept_id integer,
	denominator_value float,
	denominator_unit_concept_id integer,
	box_size integer,
	valid_start_date date NOT NULL,
	valid_end_date date NOT NULL,
	invalid_reason varchar(1));
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.DRUG_ERA', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EMILIANODELIA.DBO.DRUG_ERA

	CREATE TABLE BBDD_EMILIANODELIA.DBO.DRUG_ERA (
	drug_era_id integer NOT NULL,
	person_id integer NOT NULL,
	drug_concept_id integer NOT NULL,
	drug_era_start_date date NOT NULL,
	drug_era_end_date date NOT NULL,
	drug_exposure_count integer NULL,
	gap_days integer NULL );

END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.NOTE', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.NOTE

	CREATE TABLE NOTE (
    note_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
    person_id integer NOT NULL,
    note_date date NOT NULL,
    note_datetime datetime,
    note_type_concept_id integer NOT NULL,
    note_class_concept_id integer NOT NULL,
    note_title varchar(250),
    note_text varchar(MAX) NOT NULL,
    encoding_concept_id integer NOT NULL,
    language_concept_id integer NOT NULL,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    note_source_value varchar(50),
    note_event_id integer,
    note_event_field_concept_id integer);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.NOTE_NLP', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.NOTE_NLP

	CREATE TABLE NOTE_NLP (
    note_nlp_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
    note_id integer NOT NULL,
    section_concept_id integer,
    snippet varchar(250),
    offset varchar(50),
    lexical_variant varchar(250) NOT NULL,
    note_nlp_concept_id integer,
    note_nlp_source_concept_id integer,
    nlp_system varchar(250),
    nlp_date date NOT NULL,
    nlp_datetime datetime,
    term_exists varchar(1),
    term_temporal varchar(50),
    term_modifiers varchar(2000));
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.PAYER_PLAN_PERIOD', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.PAYER_PLAN_PERIOD

	CREATE TABLE PAYER_PLAN_PERIOD (
    payer_plan_period_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
    person_id integer NOT NULL,
    payer_plan_period_start_date date NOT NULL,
    payer_plan_period_end_date date NOT NULL,
    payer_concept_id integer,
    payer_source_value varchar(50),
    payer_source_concept_id integer,
    plan_concept_id integer,
    plan_source_value varchar(50),
    plan_source_concept_id integer,
    sponsor_concept_id integer,
    sponsor_source_value varchar(50),
    sponsor_source_concept_id integer,
    family_source_value varchar(50),
    stop_reason_concept_id integer,
    stop_reason_source_value varchar(50),
    stop_reason_source_concept_id integer);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.SPECIMEN', 'U') IS NULL 
BEGIN

	--DROP TABLE BBDD_EmilianoDelia.DBO.SPECIMEN

	CREATE TABLE SPECIMEN (
    specimen_id integer NOT NULL PRIMARY KEY NONCLUSTERED,
    person_id integer NOT NULL,
    specimen_concept_id integer NOT NULL,
    specimen_type_concept_id integer NOT NULL,
    specimen_date date,
    specimen_datetime datetime,
    quantity float,
    unit_concept_id integer,
    anatomic_site_concept_id integer,
    disease_status_concept_id integer,
    specimen_source_id varchar(50),
    specimen_source_value varchar(50),
    unit_source_value varchar(50),
    anatomic_site_source_value varchar(50),
    disease_status_source_value varchar(50));
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.FACT_RELATIONSHIP', 'U') IS NULL 
BEGIN
	
	--DROP TABLE BBDD_EmilianoDelia.DBO.FACT_RELATIONSHIP

	CREATE TABLE FACT_RELATIONSHIP (
	domain_concept_id_1 integer NOT NULL,
	fact_id_1 integer NOT NULL,
	domain_concept_id_2 integer NOT NULL,
	fact_id_2 integer NOT NULL,
	relationship_concept_id integer NOT NULL);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.METADATA', 'U') IS NULL 
BEGIN
	
	--DROP TABLE BBDD_EmilianoDelia.DBO.METADATA

	CREATE TABLE METADATA (
	metadata_id INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
	metadata_concept_id INT NOT NULL,
	metadata_type_concept_id INT NOT NULL,
	name VARCHAR(250) NOT NULL,
	value_as_string VARCHAR(250),
	value_as_concept_id INT,
	value_as_number FLOAT,
	metadata_date DATE,
	metadata_datetime DATETIME,
	cdm_source VARCHAR(255)
);
END;

IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.SOURCE_TO_CONCEPT_MAP', 'U') IS NULL 
BEGIN

--HINT DISTRIBUTE ON RANDOM
CREATE TABLE BBDD_EMILIANODELIA.DBO.SOURCE_TO_CONCEPT_MAP (
			source_code varchar(50) NOT NULL,
			source_concept_id integer NOT NULL,
			source_vocabulary_id varchar(max) NOT NULL,
			source_code_description varchar(255) NULL,
			target_concept_id integer NOT NULL,
			target_vocabulary_id varchar(20) NOT NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason varchar(1) NULL
);
END;


IF OBJECT_ID('BBDD_EMILIANODELIA.DBO.CDM_SOURCE', 'U') IS NULL 
BEGIN

CREATE TABLE BBDD_EMILIANODELIA.DBO.cdm_source (
			cdm_source_name varchar(255) NOT NULL,
			cdm_source_abbreviation varchar(25) NOT NULL,
			cdm_holder varchar(255) NOT NULL,
			source_description varchar(MAX) NULL,
			source_documentation_reference varchar(255) NULL,
			cdm_etl_reference varchar(255) NULL,
			source_release_date date NOT NULL,
			cdm_release_date date NOT NULL,
			cdm_version varchar(10) NULL,
			cdm_version_concept_id integer NOT NULL,
			vocabulary_version varchar(20) NOT NULL 
);
END;
