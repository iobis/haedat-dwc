select
	eventID,
	occurrenceID,
	occurrenceRemarks,
	scientificName,
	case
		when scientificName = 'Microcystis spp.' then 'urn:lsid:marinespecies.org:taxname:146557'
		when scientificName = 'Microcystis sp.' then 'urn:lsid:marinespecies.org:taxname:146557'
		when scientificName = 'Nitzschia sp.' then 'urn:lsid:marinespecies.org:taxname:149045'
		when scientificName = 'Dolichospermum spp.' then 'urn:lsid:marinespecies.org:taxname:578476'
		when scientificName = 'Dinophysis ovum Schütt sensu Martin 1929' then 'urn:lsid:marinespecies.org:taxname:109642'
		when scientificName = 'Gonyaulax spinifera' then 'urn:lsid:marinespecies.org:taxname:110041'
		else null
	end as scientificNameID,
	organismQuantity,
	organismQuantityType,
	'HumanObservation' as basisOfRecord,
	'present' as occurrenceStatus,
	'IOC-UNESCO' as institutionCode,
	'HAEDAT' as collectionCode,
	'HAEDAT' as datasetName
from
(
	select
		concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
		concat('HAEDAT:', grid.gridCode, ':', eventName, ':causative:', ehcs.causativeSpeciesID) as occurrenceID,
		comments as occurrenceRemarks,
		species.name as scientificName,
		cells_litre as organismQuantity,
		case when nullif(cells_litre, '') is not null then 'cells per litre' else '' end as organismQuantityType
	from event
	inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
	left join grid on eg.`grid_gridCode` = grid.gridCode
	left join event_has_causative_species ehcs on ehcs.event_id_events = event.id_events 
	left join species on species.speciesID = ehcs.species_speciesID 
	union all
	select
		concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
		concat('HAEDAT:', grid.gridCode, ':', eventName, ':additional:', ehas.additionalSpeciesID) as occurrenceID,
		comments as occurrenceRemarks,
		species.name as scientificName,
		cells_litre as organismQuantity,
		case when nullif(cells_litre, '') is not null then 'cells per litre' else '' end as organismQuantityType
	from event
	inner join event_has_grid eg on eg.`event_id_events` = event.`id_events`
	left join grid on eg.`grid_gridCode` = grid.gridCode
	left join event_has_additional_species ehas on ehas.event_id_events = event.id_events 
	left join species on species.speciesID = ehas.species_speciesID 
) t
where scientificName is not null;