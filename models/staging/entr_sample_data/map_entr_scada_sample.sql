with
    src as (select * from {{ref('seed_la_haute_borne_scada_tag_map')}})

select
    CAST(tag_name as {{dbt_utils.type_string()}}) as tag_name,
    CAST(tag_is_new as {{dbt_utils.type_string()}}) as tag_is_new,
    CAST(variable_name as {{dbt_utils.type_string()}}) as variable_name,
    CAST(variable_long_name as {{dbt_utils.type_string()}}) as variable_long_name,
    CAST(unit_long_name as {{dbt_utils.type_string()}}) as unit_long_name,
    CAST(comment as {{dbt_utils.type_string()}}) as comment
from src
