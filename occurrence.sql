select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	concat('HAEDAT:', grid.gridCode, ':', eventName, ':causative:', ehcs.causativeSpeciesID) as occurrenceID,
	comments as occurrenceRemarks,
	species.name as scientificName,
	cells_litre as organismQuantity,
	case when nullif(cells_litre, '') is not null then 'cells per litre' else '' end as organismQuantityType,
	'HumanObservation' as basisOfRecord,
	'present' as occurrenceStatus
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
left join event_has_causative_species ehcs on ehcs.event_id_events = event.id_events 
left join species on species.speciesID = ehcs.species_speciesID 
where species.name is not null
union all
select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	concat('HAEDAT:', grid.gridCode, ':', eventName, ':additional:', ehas.additionalSpeciesID) as occurrenceID,
	comments as occurrenceRemarks,
	species.name as scientificName,
	cells_litre as organismQuantity,
	case when nullif(cells_litre, '') is not null then 'cells per litre' else '' end as organismQuantityType,
	'HumanObservation' as basisOfRecord,
	'present' as occurrenceStatus
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
left join event_has_additional_species ehas on ehas.event_id_events = event.id_events 
left join species on species.speciesID = ehas.species_speciesID 
where species.name is not null;