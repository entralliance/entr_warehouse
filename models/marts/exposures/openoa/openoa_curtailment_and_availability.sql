{% set src_model = 'int_openoa_plant_curtail_avail_data__filtered' %}

with
    src as (select * from {{ ref(src_model) }})

select
    plant_id,
    plant_name,
    date_time,
    {{  
        dbt_utils.pivot(
            column = 'entr_tag_name',
            values = dbt_utils.get_column_values(table=ref(src_model), column='entr_tag_name'),
            then_value = 'tag_value',
            else_value = 'null',
            agg = 'avg',
            quote_identifiers = true) 
    }}
from src
{{ dbt_utils.group_by(n=3) }}
