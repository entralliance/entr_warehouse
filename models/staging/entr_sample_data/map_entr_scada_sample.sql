with
    src as (select * from {{ref('seed_la_haute_borne_scada_tag_map')}})

select
    cast(entr_tag_name as {{dbt_utils.type_string()}}) as entr_tag_name,
    cast(source_tag_name as {{dbt_utils.type_string()}}) as source_tag_name,
    cast(tag_is_new as {{dbt_utils.type_string()}}) as tag_is_new,
    cast(interval_s as {{dbt_utils.type_numeric()}}) as interval_s,
    cast(value_type as {{dbt_utils.type_string()}}) as value_type,
    cast(value_units as {{dbt_utils.type_string()}}) as value_units,
    cast(source_tag_long_name as {{dbt_utils.type_string()}}) as source_tag_long_name,
    cast(comment as {{dbt_utils.type_string()}}) as comment
from src
