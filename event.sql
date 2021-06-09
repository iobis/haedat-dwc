select
	concat('HAEDAT:', grid.gridCode, ':', eventName) as eventID,
	region as higherGeography,
	concat_ws(';', nullif(locationText, ''), nullif(additionalLocationInfo, '')) as locality,
	'EPSG:4326' as geodeticDatum,
	case
		when event.longitude is not null and event.latitude is not null then event.longitude
		else grid.longitude
	end as decimalLongitude,
	case
		when event.longitude is not null and event.latitude is not null then event.latitude
		else grid.latitude
	end as decimalLatitude,
	concat_ws(';',
		concat('HAEDAT event ', eventName, ' in grid ', grid.gridCode),
		nullif(additionalAlgaeInfo, ''),
		nullif(toxicityRange, ''),
		nullif(effectsComments, ''),
		nullif(pigmentAnalysisInfo, ''),
		nullif(additionalDateInfo, '')
	) as eventRemarks,
	case
		when initialDate is not null or finalDate is not null then concat_ws('/', initialDate, finalDate)
		when eventDate is not null then eventDate
		else eventYear
	end as eventDate,
	country.countryName as country,
	polygons.wkt as footprintWKT,
	case
		when polygons.radius is not null then polygons.radius
		when event.longitude is not null and event.latitude is not null then 10000
		else 100000
	end as coordinateUncertaintyInMeters
from event
inner join event_has_grid ehg on ehg.event_id_events = event.id_events 
left join grid on grid.gridCode = ehg.grid_gridCode 
left join country on country.countryID = event.country_countryCode
left join (
	select
		gridCode,
		concat('POLYGON(', group_concat(lonlat order by ordering separator ','), ')') as wkt,
		round(6378.137 * 1000 * asin(sqrt(pow(sin((max(latitude) - min(latitude)) / 2 * pi() / 180), 2) + cos(min(latitude) * pi() / 180) * cos(max(latitude) * pi() / 180) * pow(sin((max(longitude) - min(longitude)) / 2 * pi() / 180), 2)))) as radius
	from (
		select gridcode, lonlat, longitude, latitude, ordering from (
			select
				gridCode,
				concat(longitude, ' ', latitude) as lonlat,
				longitude,
				latitude,
				ordering
			from grid_coordinates gc
			union all
			select
				gridCode,
				concat(longitude, ' ', latitude) as lonlat,
				longitude,
				latitude,
				9999 as ordering
			from grid_coordinates gc
			where ordering = 1
		) t order by gridCode, ordering
	) coords
	group by gridCode
) polygons on polygons.gridCode = grid.gridCode;