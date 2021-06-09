select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	concat('HAEDAT:', grid.gridCode, ':', eventName, ':causative:', ehcs.causativeSpeciesID) as occurrenceID,
	'abundance' as measurementType,
	'http://vocab.nerc.ac.uk/collection/P01/current/SDBIOL01/' as measurementTypeID,
	cells_litre as measurementValue,
	'cells per litre' as measurementUnit,
	'http://vocab.nerc.ac.uk/collection/P06/current/UCPL/' as measurementUnitID
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
left join event_has_causative_species ehcs on ehcs.event_id_events = event.id_events 
left join species on species.speciesID = ehcs.species_speciesID 
where species.name is not null and nullif(cells_litre, '') is not null
union all
select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	concat('HAEDAT:', grid.gridCode, ':', eventName, ':additional:', ehas.additionalSpeciesID) as occurrenceID,
	'abundance' as measurementType,
	'http://vocab.nerc.ac.uk/collection/P01/current/SDBIOL01/' as measurementTypeID,
	cells_litre as measurementValue,
	'cells per litre' as measurementUnit,
	'http://vocab.nerc.ac.uk/collection/P06/current/UCPL/' as measurementUnitID
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
left join event_has_additional_species ehas on ehas.event_id_events = event.id_events 
left join species on species.speciesID = ehas.species_speciesID 
where species.name is not null and nullif(cells_litre, '') is not null
union all
select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	null as occurrenceID,
	'HAB associated illness' as measurementType,
	null as measurementTypeID,
	syndrome.syndromeName as measurementValue,
	null as measurementUnit,
	null as measurementUnitID
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
left join event_has_syndrome ehs on ehs.event_id_events = event.id_events 
left join syndrome on syndrome.syndromeID = ehs.syndrome_syndromeID 
where syndrome.syndromeName is not null
union all
select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	null as occurrenceID,
	'toxicity' as measurementType,
	null as measurementTypeID,
	toxicityRange as measurementValue,
	null as measurementUnit,
	null as measurementUnitID
from event
inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
left join grid on eg.`grid_gridCode` = grid.gridCode
where nullif(toxicityRange, '') is not null;