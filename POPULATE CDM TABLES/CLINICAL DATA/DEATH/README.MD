## Logic behind the query 
* In HM Hospitales we only record deaths and their dates when they happen within our facilities
* There could be the case where we call a patient to confirm an appointment and a family member gives us the news that the patient we were looking for passed away recently. In these cases we only record the fact that the patient is deceased but we do not record the date of death
* Since the date of death is a required field in this table we only included death records that have an explicit date associated with it
* Deaths usually happen during admission visits, therefore, most of our death records will come from Inptatient Visit table
* Date of death is recorded as __FechaAlta__ in the table mentioned beforehand but the __HoraAlta__ field is not necessarily an accurate representation of the time of death. Time of death is usually recorded in free text format in the doctor´s note and since this field is not mandatory it can be left as __NULL__ (as indicated by the documentation)
