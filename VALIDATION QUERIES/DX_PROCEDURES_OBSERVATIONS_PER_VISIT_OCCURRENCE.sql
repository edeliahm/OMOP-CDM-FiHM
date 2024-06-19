use BBDD_EmilianoDelia;

with cte as (

select

	person_id as person_id,
	visit_occurrence_id as id_episodio, 
	observation_date as date_of_record,
	'observation' as type, 
	'' as status, 
	c1.concept_name, 
	observation_source_value

from OBSERVATION o
left join concept c1 on c1.concept_id = o.observation_concept_id and domain_id like 'observation'

where VISIT_OCCURRENCe_id like 866045

union all 


select

	person_id, 
	visit_occurrence_id, 
	condition_start_datetime, 
	'dx' as type, 
	c.condition_status_source_value, 
	c1.concept_name, 
	condition_source_value

from condition_occurrence c
left join concept c1 on c1.concept_id = c.condition_concept_id and domain_id like 'condition'

where VISIT_OCCURRENCe_id like 866045

union all 


select

	person_id, 
	visit_occurrence_id, 
	procedure_datetime, 
	'procedure' as type, 
	'' as test, 
	c1.concept_name, 
	procedure_source_value

from procedure_occurrence p
left join concept c1 on c1.concept_id = p.procedure_concept_id and domain_id like 'procedure'

where VISIT_OCCURRENCe_id like 866045

)

select * from cte 
order by type asc, observation_source_value asc

