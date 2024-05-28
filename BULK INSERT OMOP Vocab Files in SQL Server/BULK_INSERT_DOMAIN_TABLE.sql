use BBDD_EmilianoDelia

BULK INSERT DOMAIN

FROM 'E:\Archivos BULK INSERT\DOMAIN.csv'

WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  ROWTERMINATOR='\n',
	  BATCHSIZE=250000
);  


/* INSERTING ROW THAT IS CAUSING TROUBLE */
INSERT INTO BBDD_EmilianoDelia.dbo.DOMAIN (domain_id, domain_name, domain_concept_id)
VALUES ('Plan', 'Health Plan - contract to administer healthcare transactions by the payer, facilitated by the sponsor', 32475);

select * from domain order by domain_id asc