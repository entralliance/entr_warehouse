with
    src as (select * from {{ref('seed_plant_data_tag_map')}})

select
    cast(entr_tag_name as {{dbt_utils.type_string()}}) as entr_tag_name,
    cast(source_tag_name as {{dbt_utils.type_string()}}) as source_tag_name,
    cast(interval_n as {{dbt_utils.type_numeric()}}) as interval_n,
    cast(interval_units as {{dbt_utils.type_string()}}) as interval_units,
    cast(value_type as {{dbt_utils.type_string()}}) as value_type,
    cast(value_units as {{dbt_utils.type_string()}}) as value_units
from src
