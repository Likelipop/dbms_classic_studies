truncate
	table staging.stg_geolocation;

insert
	into
	staging.stg_geolocation(
    geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
select
	distinct on
	(
    rogd.geolocation_zip_code_prefix,
	rogd.geolocation_city,
	rogd.geolocation_state
)
    cast(nullif(btrim(rogd.geolocation_zip_code_prefix, ' ''"'), '') as varchar(10)) as geolocation_zip_code_prefix,
	cast(nullif(btrim(rogd.geolocation_lat, ' ''"'), '') as double precision) as geolocation_lat,
	cast(nullif(btrim(rogd.geolocation_lng, ' ''"'), '') as double precision) as geolocation_lng,
	cast(nullif(btrim(rogd.geolocation_city, ' ''"'), '') as varchar(100)) as geolocation_city,
	cast(nullif(btrim(rogd.geolocation_state, ' ''"'), '') as char(2)) as geolocation_state
from
	raw.olist_geolocation_dataset rogd
where
	nullif(btrim(rogd.geolocation_zip_code_prefix, ' ''"'), '') is not null
order by
	rogd.geolocation_zip_code_prefix,
	rogd.geolocation_city,
	rogd.geolocation_state;