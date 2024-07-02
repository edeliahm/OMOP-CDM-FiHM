# Repository Development and Integration with HM Hospitales' Data
This SQL code repository represents the culmination of several months of rigorous auditing and transformation trials conducted on HM Hospitales' data. During this process, we meticulously identified the datasets requiring transformation, documented the conventions of our local databases, and devised the logic governing data storage. This documentation is crucial as it dictates how data extractions from our databases should be interpreted and integrated into the OMOP-CDM framework.

Our IT department, while proficient in managing local databases, initially lacked specific experience with OMOP-CDM standards. Recognizing this gap, the development of these SQL scripts was deemed essential. They serve as a comprehensive documentation and foundational toolset, ensuring that subsequent high-level Extract, Transform, Load (ETL) design efforts align seamlessly with our data conventions and OMOP-CDM requirements.

Official reference vocabularies were downloaded from OHDSI’s Athena webpage -> https://athena.ohdsi.org/search-terms/start

The data was transformed and loaded into tables corresponding to the OMOP Common Data Model v5.4 schema, which is the latest version of OMOP CDM -> https://ohdsi.github.io/CommonDataModel/cdm54.html#death

The following Google Drive link contains files with precise and detailed descriptions of the conceptual conventions of each table and their respective [content]. This resource is included as supporting documentation -> https://drive.google.com/drive/folders/1DaNKe6ivIAZPJeI31VJ-pzNB9wS9hDqu

# Summary
In the following repository, SQL scripts are provided for:

* Creating tables corresponding to the model
* Establishing integrity rules and relationships between tables (PKs & FKs)
* Uploading necessary reference tables into an SQLServer DB to facilitate mapping between internal codes and their respective standard format codes
* Extracting, Transforming, and Loading clinical information from our systems into their respective tables

# Supporting High-Level ETL Architecture Design and Implementation
The purpose of this repository of SQL scripts, mapping references, and drafted pipelines is to serve as a foundational code repository. This repository will assist in designing and implementing the high-level Extract, Transform, Load (ETL) architecture required for this project. By standardizing data extraction and transformation processes according to OMOP-CDM standards and incorporating necessary mappings, these scripts ensure that clinical information from HM Hospitales can be integrated seamlessly into the data model. This approach not only supports the current data integration efforts but also lays the groundwork for scalable and efficient data management practices across the project lifecycle.
 
 ![OMOP](https://github.com/edeliahm/OMOP-CDM-FiHM/assets/144276034/d6fa6647-8cb5-45a2-9eaf-76c904a14768)

