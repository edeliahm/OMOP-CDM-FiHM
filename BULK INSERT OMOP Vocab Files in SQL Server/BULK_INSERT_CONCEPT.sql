use BBDD_EmilianoDelia

DROP TABLE CONCEPT

CREATE TABLE BBDD_EmilianoDelia.dbo.CONCEPT (
			concept_id integer PRIMARY KEY NOT NULL,
			concept_name varchar(255) NOT NULL,
			domain_id varchar(20) NOT NULL /*FOREIGN KEY REFERENCES BBDD_EMILIANODELIA.DBO.DOMAIN(DOMAIN_ID)*/,
			vocabulary_id varchar(20) NOT NULL /*FOREIGN KEY REFERENCES BBDD_EMILIANODELIA.DBO.VOCABULARY(VOCABULARY_ID)*/,
			concept_class_id varchar(20) NOT NULL /*FOREIGN KEY REFERENCES BBDD_EMILIANODELIA.DBO.CONCEPT_CLASS(concept_class_id)*/,
			standard_concept varchar(1) NULL,
			concept_code varchar(50) NOT NULL,
			valid_start_date date NOT NULL,
			valid_end_date date NOT NULL,
			invalid_reason varchar(1) NULL );

BULK INSERT CONCEPT

/* TABLE SHOULD END UP WITH 9,441,375 TOTAL ROWS */

FROM 'E:\Archivos BULK INSERT\CONCEPT.csv'

	WITH (
	FORMAT ='CSV', 
	CODEPAGE = '65001', -- UTF-8 codepage
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK, 
	BATCHSIZE=250000,
	KEEPNULLS, 
	MAXERRORS=250000
);  

SELECT * FROM CONCEPT