# OMOP-CDM-FiHM
Queries escritas para SQL Server para extraer datos provenientes de las base de datos central de HM Hospitales y transformalos basandonos en el modelo de datos OMOP CDM

# Resumen
En el siguiente reposisitorio se encuentran los scripts de SQL usados para
* Crear las tablas correspondientes al modelo
* Crear las reglas de integridad y relaciones entre tablas (PKs & FKs)
* Subir las tablas de referencia necesarias una BBBDD de SQLServer para poder hacer el mapeo entre códigos internos y sus respectivos códigos en formato estándar
* Extraer, Tranformar y Subir información clínica provenientes de nuestros sistemas en sus tablas correspondientes

# Puntos importantes a tener en cuenta a la hora de orquestar los procesos ETL
* Las tablas __PERSON__ y __VISIT_OCCURRENCE__ son nuestras tablas principales y deben existir ya pobladas en el modelo antes de poblar el resto de tablas que van a contener informacón clínica 
* Toda la información clínica que extraigamos de HOSMA y HOSMA-DOCTOR debe tener un id_episodio y un id_paciente existente en las tablas anteriormente mencioandas para poder ser incluidas en las tablas del modelo de datos OMOP

* Solo se extrajo información clínica estandarizada de nuestros sistemas 
  * Información demográfica de los pacientes
     * Fecha de nacimiento
     * Sexo
  * Diagnósticos (CIE10)
  * Procedimientos clínicos (CIE10)
  * Medicamentos administrados en episodios de ingresos y ambulantes (Códigos nacionales de medicamentos)
  * Resultados de pruebas de laboratorios
