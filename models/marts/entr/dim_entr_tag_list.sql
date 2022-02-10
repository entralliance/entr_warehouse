{{
    config(materialized='table')
}}

select
    CAST(entr_tag_id as {{dbt_utils.type_int()}}) as entr_tag_id,
    CAST(entr_tag_name as {{dbt_utils.type_string()}}) as entr_tag_name,
    CAST(logical_node as {{dbt_utils.type_string()}}) as logical_node,
    CAST(sensor_name as {{dbt_utils.type_string()}}) as sensor_name,
    CAST(presentation_name as {{dbt_utils.type_string()}}) as presentation_name,
    CAST(si_unit as {{dbt_utils.type_string()}}) as si_unit,
    CAST(value_type as {{dbt_utils.type_string()}}) as value_type,
    CAST(data_type as {{dbt_utils.type_string()}}) as data_type,
    CAST(collector_type as {{dbt_utils.type_string()}}) as collector_type
from
    {{ref('entr_tag_list')}}
