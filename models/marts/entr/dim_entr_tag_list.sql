{{
    config(materialized='table')
}}

select
    cast(entr_tag_id as {{dbt_utils.type_int()}}) as entr_tag_id,
    cast(entr_tag_name as {{dbt_utils.type_string()}}) as entr_tag_name,
    cast(logical_node as {{dbt_utils.type_string()}}) as logical_node,
    cast(sensor_name as {{dbt_utils.type_string()}}) as sensor_name,
    cast(presentation_name as {{dbt_utils.type_string()}}) as presentation_name,
    cast(standard_units as {{dbt_utils.type_string()}}) as standard_units,
    cast(value_type as {{dbt_utils.type_string()}}) as value_type,
    cast(data_type as {{dbt_utils.type_string()}}) as data_type,
    cast(collector_type as {{dbt_utils.type_string()}}) as collector_type
from
    {{ref('seed_entr_tag_list')}}
