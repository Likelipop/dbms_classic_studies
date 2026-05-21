truncate
	table staging.stg_products;

insert
	into
	staging.stg_products(
    product_id,
	product_category_name,
	product_name_length,
	product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
select
	distinct on
	(ropd.product_id)
    cast(nullif(btrim(ropd.product_id, ' ''"'), '') as uuid) as product_id,
	cast(nullif(btrim(ropd.product_category_name, ' ''"'), '') as text) as product_category_name,
	cast(nullif(btrim(ropd.product_name_length, ' ''"'), '') as integer) as product_name_length,
	cast(nullif(btrim(ropd.product_description_length, ' ''"'), '') as integer) as product_description_length,
	cast(nullif(btrim(ropd.product_photos_qty, ' ''"'), '') as integer) as product_photos_qty,
	cast(nullif(btrim(ropd.product_weight_g, ' ''"'), '') as integer) as product_weight_g,
	cast(nullif(btrim(ropd.product_length_cm, ' ''"'), '') as integer) as product_length_cm,
	cast(nullif(btrim(ropd.product_height_cm, ' ''"'), '') as integer) as product_height_cm,
	cast(nullif(btrim(ropd.product_width_cm, ' ''"'), '') as integer) as product_width_cm
from
	raw.olist_products_dataset ropd
where
	nullif(btrim(ropd.product_id, ' ''"'), '') is not null
order by
	ropd.product_id

on
	conflict (product_id) do
update
set
	product_category_name = excluded.product_category_name,
	product_name_length = excluded.product_name_length,
	product_description_length = excluded.product_description_length,
	product_photos_qty = excluded.product_photos_qty,
	product_weight_g = excluded.product_weight_g,
	product_length_cm = excluded.product_length_cm,
	product_height_cm = excluded.product_height_cm,
	product_width_cm = excluded.product_width_cm;