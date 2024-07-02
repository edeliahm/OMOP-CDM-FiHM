# OMOP-CDM-FiHM
SQL scripts for extracting data from HM Hospitales' databases and transforming it based on the OMOP-CDM data model criteria.

Official reference vocabularies were downloaded from OHDSI’s Athena webpage -> https://athena.ohdsi.org/search-terms/start

The data was transformed and loaded into tables corresponding to the OMOP Common Data Model v5.4 schema, which is the latest version of OMOP CDM -> https://ohdsi.github.io/CommonDataModel/cdm54.html#death

The following Google Drive link contains files with precise and detailed descriptions of the conceptual conventions of each table and their respective [content]. This resource is included as supporting documentation -> https://drive.google.com/drive/folders/1DaNKe6ivIAZPJeI31VJ-pzNB9wS9hDqu

# Summary
En el siguiente reposisitorio se encuentran los scripts de SQL usados para
* Crear las tablas correspondientes al modelo
* Crear las reglas de integridad y relaciones entre tablas (PKs & FKs)
* Subir las tablas de referencia necesarias una BBDD de SQLServer para poder hacer el mapeo entre códigos internos y sus respectivos códigos en formato estándar
* Extraer, Tranformar y Subir información clínica provenientes de nuestros sistemas en sus tablas correspondientes

# Puntos importantes a tener en cuenta a la hora de orquestrar los procesos ETL
* Las tablas __PERSON__ y __VISIT_OCCURRENCE__ son nuestras tablas principales y deben existir ya pobladas en el modelo antes de poblar el resto de tablas que van a contener informacón clínica 
* Toda la información clínica que extraigamos de HOSMA y HOSMA-DOCTOR debe tener un __id_episodio__ y un __id_paciente__ existente en las tablas anteriormente mencioandas para poder ser incluidas en las tablas del modelo de datos OMOP

* Solo se extrajo información clínica estandarizada de nuestros sistemas 
  * Información demográfica de los pacientes
     * Fecha de nacimiento
     * Sexo
  * Diagnósticos (CIE10)
  * Procedimientos clínicos (CIE10)
  * Medicamentos administrados en episodios de ingresos y ambulantes (Códigos nacionales de medicamentos)
  * Resultados de pruebas de laboratorios
 
 ![OMOP](https://github.com/edeliahm/OMOP-CDM-FiHM/assets/144276034/d6fa6647-8cb5-45a2-9eaf-76c904a14768)

