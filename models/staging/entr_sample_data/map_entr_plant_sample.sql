with
    src as (select * from {{ref('seed_plant_data_tag_map')}})

select
    cast(tag_name as {{dbt_utils.type_string()}}) as tag_name,
    cast(variable_name as {{dbt_utils.type_string()}}) as variable_name
from src
