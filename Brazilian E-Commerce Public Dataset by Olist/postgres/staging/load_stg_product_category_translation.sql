truncate
	table staging.stg_product_category_translation;

insert
	into
	staging.stg_product_category_translation(
    product_category_name,
	product_category_name_english
)
select
	distinct on
	(rpcnt.product_category_name)
    cast(nullif(btrim(rpcnt.product_category_name, ' ''"'), '') as text) as product_category_name,
	cast(nullif(btrim(rpcnt.product_category_name_english, ' ''"'), '') as text) as product_category_name_english
from
	raw.product_category_name_translation rpcnt
where
	nullif(btrim(rpcnt.product_category_name, ' ''"'), '') is not null
order by
	rpcnt.product_category_name

on
	conflict (product_category_name) do
update
set
	product_category_name_english = excluded.product_category_name_english;