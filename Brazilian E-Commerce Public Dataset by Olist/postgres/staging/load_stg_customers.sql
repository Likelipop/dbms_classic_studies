truncate
	table staging.stg_customers;

insert
	into
	staging.stg_customers(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
select
	distinct on
	(rocd.customer_id)
	cast(nullif(btrim(rocd.customer_id, ' ''"'), '') as uuid) as customer_id,

	cast(nullif(btrim(rocd.customer_unique_id, ' ''"'), '') as uuid) as customer_unique_id,

	cast(nullif(btrim(rocd.customer_zip_code_prefix, ' ''"'), '') as integer) as customer_zip_code_prefix,

	cast(nullif(btrim(rocd.customer_city, ' ''"'), '') as text) as customer_city,

	cast(nullif(btrim(rocd.customer_state, ' ''"'), '') as text) as customer_state
from
	raw.olist_customers_dataset rocd
order by
	rocd.customer_id

on
	conflict (customer_id) do
update
set
	customer_id = excluded.customer_id,
	customer_unique_id = excluded.customer_unique_id,
	customer_zip_code_prefix = excluded.customer_zip_code_prefix,
	customer_city = excluded.customer_city,
	customer_state = excluded.customer_state;